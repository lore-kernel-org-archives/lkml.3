Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3BEVYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:24:33 -0500
Received: from meriadoc.sigma-star.at ([178.63.61.2]:47711 "EHLO
	meriadoc.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab3BEVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:24:32 -0500
X-Greylist: delayed 2556 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 16:24:32 EST
Date: Tue, 5 Feb 2013 21:41:46 +0100
From: Richard Weinberger <richard@sigma-star.at>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gstir <david@sigma-star.at>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DMAR faults from unrelated device when vfio is used
Message-ID: <20130205214146.4be295ad@spider.haslach.nod.at>
In-Reply-To: <1360096613.11144.612.camel@bling.home>
References: <1359972630.2498.21.camel@riven-lux.site>
	<1359992968.11144.414.camel@bling.home>
	<1360071110.6200.19.camel@riven-lux.site>
	<1360078648.11144.558.camel@bling.home>
	<1360096613.11144.612.camel@bling.home>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 05 Feb 2013 13:36:53 -0700
schrieb Alex Williamson <alex.williamson@redhat.com>:
> > Ugh, the infamous and useless error 10.  It could be anything.
> > I've got a system with onboard usb3, let me see what windows does
> > with it here first.  Thanks,
> 
> Well, I've got an Etron USB3 HBA and (un)fortunately it works just
> fine with a Win7 guest.  There's really nothing special about USB
> controllers from a PCI device assignment perspective.  Have you tried
> the latest upstream qemu bits?  Thanks,

We tried also qemu v1.4.0-rc0 (git as of today) without success.
As next step we'll test Linux as guest, maybe it is more chatty than
Windows regarding the issue. :-)

Thanks,
//richard
