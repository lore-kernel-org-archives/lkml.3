Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbbALV7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:59:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbbALV7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:59:22 -0500
Date: Mon, 12 Jan 2015 21:59:41 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Thomas Voegtle <tv@lio96.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.16.y-ckt stable] Linux 3.16.7-ckt4 stable review
Message-ID: <20150112215941.GJ2455@charon>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
 <alpine.LSU.2.11.1501122121450.16281@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.11.1501122121450.16281@er-systems.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:30:45PM +0100, Thomas Voegtle wrote:
> On Mon, 12 Jan 2015, Luis Henriques wrote:
> 
> >This is the start of the review cycle for the Linux 3.16.7-ckt4 stable kernel.
> >
> >This version contains 216 new patches, summarized below.  The new patches are
> >posted as replies to this message and also available in this git branch:
> >
> >http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.16.y-review;a=shortlog
> >
> >git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.16.y-review
> >
> >The review period for version 3.16.7-ckt4 will be open for the next three days.
> >To report a problem, please reply to the relevant follow-up patch message.
> >
> >For more information about the Linux 3.16.y-ckt extended stable kernel version,
> >see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .
> 
> 
> Something is wrong with drm/i915 (I guess). I had a terrible memleak on Xorg
> when using mplayer using more and more RAM, and then the system is swapping
> itself to death.
> 
> I'm using a openSUSE 13.1 (x86_64) on a Baytrail J1900 (this is Intel HD
> Gen7).
> 
> 

Thank you for reporting, Thomas.  Can you please confirm that this is
actually a regression in 3.16.7-ckt4 (i.e., that you can't reproduce
it in 3.16.7-ckt3)?  If so, is it possible to bisecting it?

Cheers,
--
Luís

>       Thomas
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
