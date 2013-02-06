Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab3BFVXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:23:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54059 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337Ab3BFVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:23:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Borislav Petkov <bp@suse.de>, Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Wed, 06 Feb 2013 22:29:54 +0100
Message-ID: <1896930.yhFM10tt3d@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51126078.2050504@suse.cz>
References: <20130129202848.GE25415@pd.tnic> <2293454.v8QRHr8txR@vostro.rjw.lan> <51126078.2050504@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2013 02:54:00 PM Jiri Slaby wrote:
> On 02/03/2013 12:04 AM, Rafael J. Wysocki wrote:
> > On Thursday, January 31, 2013 02:10:34 PM Borislav Petkov wrote:
> >> On Thu, Jan 31, 2013 at 02:12:58PM +0100, Rafael J. Wysocki wrote:
> >>> Yes, there are two bugs in e1000e, it appears. Konstantin's
> >>> patch [2/5] fixes one of them, but the other one has to be fixed
> >>> differently.
> >>>
> >>> Boris, would you be able to test a couple of e1000e patches for me?
> >>
> >> Sure, send them on. You can add 2/5 in the mix too.
> > 
> > There you go.
> > 
> > The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
> > 
> > The other two are attached.  I suppose the ordering doesn't matter.
> 
> Just a side question, are these going to be merged some time soon? I
> don't even see them in -next and I would like to backport them to
> opensuse as they affect also 3.7...

Not these particular patches, but there's a series on linux-pci from
Konstantin Khlebnikov that is functionally equivalent.  I'm not sure who's
going to take that, though.  I've acked it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
