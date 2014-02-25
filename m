Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaBYOUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:20:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48828 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbaBYOUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:20:49 -0500
Message-ID: <530CA6BA.1000405@ti.com>
Date: Tue, 25 Feb 2014 16:20:42 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mfd: twl6040: Small clean-ups
References: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:28 PM, Florian Vaussard wrote:
> Hi,
> 
> Here is two cleanups patches for the TWL6040 audio codec. The first
> one checks for an error when reading the revision register (first read
> in the probe path). The second removes a duplicate I2C writes.
> 
> Regards,
> Florian

To both:
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Florian Vaussard (2):
>   mfd: twl6040: Check for error when reading revision register
>   mfd: twl6040: Remove duplicate register write
> 
>  drivers/mfd/twl6040.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 


-- 
Péter
