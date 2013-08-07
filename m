Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3HGFvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:51:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab3HGFvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:51:08 -0400
Date: Wed, 7 Aug 2013 14:52:27 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
Message-ID: <20130807055227.GB5304@kroah.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com>
 <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com>
 <20130806093356.GA27889@kroah.com>
 <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com>
 <20130806101421.GA29283@kroah.com>
 <5200FC09.7080108@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5200FC09.7080108@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 03:37:13PM +0200, Alexander Holler wrote:
> Am 06.08.2013 12:14, schrieb Greg Kroah-Hartman:
> 
> >> What exactly is a platform device anyway?
> > 
> > Originally it was a "something that wasn't connected to a bus, but just
> > had memory-mapped i/o."  Like the PS2 keyboard controller.
> > 
> > Embedded systems got ahold of this and went to town, and made everything
> > a platform device because they could, and no one was paying attention.
> > 
> > Then OF came along and used it as well, and you know the rest...
> > 
> > I think we need to get the ACPI and OF people, and me, in a room
> > together at the kernel summit and not let us out until we have this all
> > worked out.
> 
> MFD uses platform devices too.

Ugh, I've been avoiding looking at mfd for a long time now, and really
don't want to start now...

