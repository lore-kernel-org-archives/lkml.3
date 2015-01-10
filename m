Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbbAJWZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:25:51 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38218 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbbAJWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:25:50 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
        pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: Getting new udev to run with 2.6.28
Date: Sat, 10 Jan 2015 23:25:39 +0100
Message-ID: <7348917.heGelKEtgq@merkaba>
User-Agent: KMail/4.14.2 (Linux/3.19.0-rc3-tp520-trim-all-bgroups+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20150110211857.GA22149@ZenIV.linux.org.uk>
References: <20150110173920.GA31847@amd> <20150110181710.GA8884@kroah.com> <20150110211857.GA22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 10. Januar 2015, 21:18:58 schrieb Al Viro:
> On Sat, Jan 10, 2015 at 10:17:10AM -0800, Greg KH wrote:
> > > > Yes, 3.18, please use that instead.
> > > 
> > > Can't, sorry. My goal is to get 3.18/3.19 working, but I really need
> > > working kernel to debug userland (and then use that userland to debug
> > > kernel).> > 
> > > > Seriously, lots of things have changed, if you want to run a "new"
> > > > version of udev with an old kernel, try eudev, they have been
> > > > attempting
> > > > to keep "legacy" support around in it, don't know how well it has been
> > > > working though, you really are on your own.
> > > 
> > > I was hoping someone has devtmpfs patches I could just apply over
> > > 2.6.28 and get a working system?
> > 
> > If you want such a crazy thing, you have all of the source to do it
> > yourself, good luck.
> 
> ... and this, boys and girls, is why quite a few of us have loathed udev
> way before it got merged into even nastier shitpile.  Still do, for that
> matter.

You mean systemd by that?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
