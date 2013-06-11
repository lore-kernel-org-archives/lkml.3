Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3FKOXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:23:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:18558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3FKOXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:23:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="315348816"
Date: Tue, 11 Jun 2013 16:23:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>
Subject: Re: [PATCH 04/22] input/ti_am33x_tsc: Order of TSC wires, made
 configurable
Message-ID: <20130611142324.GD29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <1370950268-7224-5-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370950268-7224-5-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, Jun 11, 2013 at 01:30:50PM +0200, Sebastian Andrzej Siewior wrote:
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index eeead15..2d78af8 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -71,8 +71,6 @@
>  #define STEPCONFIG_INM_ADCREFM	STEPCONFIG_INM(8)
>  #define STEPCONFIG_INP_MASK	(0xF << 19)
>  #define STEPCONFIG_INP(val)	((val) << 19)
> -#define STEPCONFIG_INP_AN2	STEPCONFIG_INP(2)
> -#define STEPCONFIG_INP_AN3	STEPCONFIG_INP(3)
>  #define STEPCONFIG_INP_AN4	STEPCONFIG_INP(4)
>  #define STEPCONFIG_INP_ADCREFM	STEPCONFIG_INP(8)
>  #define STEPCONFIG_FIFO1	BIT(26)
> @@ -94,7 +92,6 @@
>  #define STEPCHARGE_INM_AN1	STEPCHARGE_INM(1)
>  #define STEPCHARGE_INP_MASK	(0xF << 19)
>  #define STEPCHARGE_INP(val)	((val) << 19)
> -#define STEPCHARGE_INP_AN1	STEPCHARGE_INP(1)
>  #define STEPCHARGE_RFM_MASK	(3 << 23)
>  #define STEPCHARGE_RFM(val)	((val) << 23)
>  #define STEPCHARGE_RFM_XNUR	STEPCHARGE_RFM(1)
> @@ -116,6 +113,13 @@
>  #define CNTRLREG_8WIRE		CNTRLREG_AFE_CTRL(3)
>  #define CNTRLREG_TSCENB		BIT(7)
>  
> +#define XPP			STEPCONFIG_XPP
> +#define XNP			STEPCONFIG_XNP
> +#define XNN			STEPCONFIG_XNN
> +#define YPP			STEPCONFIG_YPP
> +#define YPN			STEPCONFIG_YPN
> +#define YNN			STEPCONFIG_YNN
What is that for ? Isn't STEPCONFIG_XPP explicit enough ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
