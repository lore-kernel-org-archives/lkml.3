Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3GNTa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:30:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3GNTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:30:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Neil Zhang <zhangwm@marvell.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Date: Sun, 14 Jul 2013 21:29:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Matt Sealey <neko@bakuhatsu.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com> <20130710214922.GQ11908@titan.lakedaemon.net> <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFA@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFA@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201307142129.43271.arnd@arndb.de>
X-Provags-ID: V02:K0:yzufvrmF/lKNZ5pSnIkXA8u1Ss2Df2DeYeLRgpxetoM
 Yv4QrYJRKjbQIoDddR1y882UTECACWqNKvprvnlh1Oh+qzBbK7
 lMwn82hNEO5fLiQ2GlRutzFJDUiY4iSt2J6KRbGmQbdwvpv9Qi
 9IkAdmkDZabORf66ZbJZ/R/uak0AD+Qn1Tdt2d1ZAoPb9kPfLC
 ZZG0LD2zmlkgf615FVBbT3oPQBLaLCAgRhH8X/Bu4SHH7S3UxL
 z+TYV6/RE1eeYxZib55QwkK4+Q73Tl5uf0PNonXx4bkeobbnqX
 +5yMjCesreFryEHiUR6lRSHlfMxJ/zehe93yNEJ8n+RTS7ApiM
 VcCZxsdJFRSN2UulhHTI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 July 2013, Neil Zhang wrote:
> > > > To do this properly, the drivers are going to have to be compatible
> > > > with the old and the new names, and the binding docs updated to
> > > > reflect the legacy name and the preferred name.
> > >
> > > Properly would be as above. You can stop using stock tickers for new
> > > company names, but anything that has been defined in a device tree
> > > before has to stay that way, and all the manufacturer prefixes to
> > > device names should be the same. What you're proposing is purely
> > > driver bloat and increasing the size of kernel.
> > 
> > *I'm* not proposing to change the name, Neil is.  I'm proposing that
> > iff they chose to do that, don't break sh*t along the way.
> > 
> 
> What's your opinion?

We discussed the topic of fixing bad bindings vs. keeping backwards
compatibility during last week's Linaro Connect.

The main outcome was that we need to have a better review for new bindings
getting merged to avoid this situation in the future, but the general
consensus seems that bindings that are already in use but were never
reviewed properly (which should have caught this) should be changed.
We will likely establish an annotation in the binding soon to mark those
that can not be changed as opposed to those that are not considered stable
yet.

	Arnd
