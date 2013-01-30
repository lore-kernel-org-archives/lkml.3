Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3A3Pys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:54:48 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36744 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3A3Pyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:54:46 -0500
Message-ID: <1359561282.3094.15.camel@hornet>
Subject: Re: [PATCH] mfd: vexpress: Add pseudo-GPIO based LEDs
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 30 Jan 2013 15:54:42 +0000
In-Reply-To: <20130130154923.GE1174@sortiz-mobl>
References: <1359541996-18127-1-git-send-email-pawel.moll@arm.com>
	 <20130130154923.GE1174@sortiz-mobl>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 30 Jan 2013 15:54:43.0167 (UTC) FILETIME=[1E945EF0:01CDFF02]
X-MC-Unique: 113013015544401301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 15:49 +0000, Samuel Ortiz wrote:
> On Wed, Jan 30, 2013 at 10:33:16AM +0000, Pawel Moll wrote:
> > The LEDs on the Versatile Express motherboard are controlled
> > through simple memory-mapped register. This patch extends
> > the pseudo-GPIO controller definition for these lines and
> > creates generic "leds-gpio" device using them
> > 
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> > 
> > Hello Samuel,
> > 
> > Would you be so kind to take this patch in for 3.9? Or would
> > you prefer to get it in through arm-soc tree?
> I'll take it through my MFD tree.

Great, thanks!

> 
> >  drivers/mfd/vexpress-sysreg.c |   73 +++++++++++++++++++++++++++++++----------
> >  include/linux/vexpress.h      |    8 +++++
> Hmmm, there is a include/linux/mfd/ directory for kernel MFD drivers, FYI.

Sure, it's just that this header "serves" whole platform, not only the
mfd drivers (eg. there are power-related declarations there as well). If
one day it gets divided, I'll make sure that the MFD portions will find
its way into ../mfd/.

Cheers!

Pawel


