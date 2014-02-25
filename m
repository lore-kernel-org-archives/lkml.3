Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaBYO1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:27:15 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65422 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaBYO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:27:11 -0500
Date: Tue, 25 Feb 2014 14:27:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Florian Vaussard <florian.vaussard@epfl.ch>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: twl6040: Small clean-ups
Message-ID: <20140225142705.GC9195@lee--X1>
References: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
 <530CA6BA.1000405@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <530CA6BA.1000405@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Here is two cleanups patches for the TWL6040 audio codec. The first
> > one checks for an error when reading the revision register (first read
> > in the probe path). The second removes a duplicate I2C writes.
> > 
> > Regards,
> > Florian
> 
> To both:
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Applied both with Peter's Ack.

> > Florian Vaussard (2):
> >   mfd: twl6040: Check for error when reading revision register
> >   mfd: twl6040: Remove duplicate register write
> > 
> >  drivers/mfd/twl6040.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
