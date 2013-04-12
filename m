Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3DLSHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:07:36 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38100 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3DLSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:07:34 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [NEW DRIVER V4 0/7] DA9058 PMIC - please comment on this new driver
Date: Fri, 12 Apr 2013 11:07:29 -0700
Message-ID: <1854273.arIzJJ3lWV@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.1 (Linux/3.9.0-rc6+; KDE/4.10.1; x86_64; ; )
In-Reply-To: <201304121307.r3CD7tDi011782@latitude>
References: <201304121307.r3CD7tDi011782@latitude>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 12, 2013 02:05:29 PM Anthony Olech wrote:
> This is submission attempt number 4 to have this driver included in
> the linux kernel source tree. This is the driver for the Dialog DA9058.
> 
> The DA9058 is a low power Power Management Integrated Circuit with extra
> functionality. It is a Multi Function Device controlled only from an I2C
> bus whose components can raise an interrupt request on a single IRQ line.
> 
> The driver for the DA9058 consists of a core (i2c) device driver that
> instantiates the individual component device drivers for:
> 
> adc - 5 ADC channels
> gpio - 2 available pins
> onkey - 1 device

I have exactly the same comment as ~6 month ago:

> On Wed, Aug 15, 2012 at 04:05:22PM +0100, Anthony Olech wrote:
> > This is the ONKEY component driver of the Dialog DA9058 PMIC.
> > This driver is just one component of the whole DA9058 PMIC driver.
> > It depends on the CORE component driver of the DA9058 MFD.
> > 
> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> 
> This is almost exact copy of da9052_onkey, can they be merged together?
> 
> Thanks.

-- 
Dmitry
