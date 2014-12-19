Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaLSXH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:07:26 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46571 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaLSXHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:07:25 -0500
Date: Fri, 19 Dec 2014 15:07:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv4] INPUT: Route keyboard LEDs through the generic LEDs
 layer.
Message-ID: <20141219230721.GA31631@dtor-glaptop>
References: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
 <20141219144641.3a549feb1ee5f2b9400f62cb@linux-foundation.org>
 <20141219225933.GD3049@type.youpi.perso.aquilenet.fr>
 <20141219230253.GA31928@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141219230253.GA31928@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 12:02:53AM +0100, Pavel Machek wrote:
> On Fri 2014-12-19 23:59:33, Samuel Thibault wrote:
> > Andrew Morton, le Fri 19 Dec 2014 14:46:41 -0800, a écrit :
> > > > Changed in this version:
> > > > - Use kcalloc instead of kzalloc
> > > > - to avoid any mutex order violation, defer LED update into a work callback.
> > > 
> > > Confused.  This patch is identical to the one that's presently in -mm.
> > 
> > Well, yes: I'm submitting the latest version of this patch to Dmitry,
> > i.e. including the fixes that happened in the -mm tree.
> 
> Andrew, do you think you could send the patch to Dmitry? He has been
> ignoring it for way too long... and it should be slightly harder for
> him to ignore patch from you...

I'll keep ignoring the patch until someone will figure out how to make new way
of handling LEDs play well with the current way (via writing to evdev). That
means not treating access to evdev as "raw" and ignoring LED trigger remapping
done in LED layer. So far I just heard that it is not a problem and nobody uses
evdev interface...

Thanks.

-- 
Dmitry
