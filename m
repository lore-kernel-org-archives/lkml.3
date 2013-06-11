Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3FKOgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:36:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:34742 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3FKOgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:36:02 -0400
Message-ID: <51B735CC.9080909@linutronix.de>
Date: Tue, 11 Jun 2013 16:35:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>
Subject: Re: [PATCH 04/22] input/ti_am33x_tsc: Order of TSC wires, made configurable
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-5-git-send-email-bigeasy@linutronix.de> <20130611142324.GD29135@zurbaran>
In-Reply-To: <20130611142324.GD29135@zurbaran>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 04:23 PM, Samuel Ortiz wrote:
> Hi Sebastian,

Hi Samuel,

> On Tue, Jun 11, 2013 at 01:30:50PM +0200, Sebastian Andrzej Siewior wrote:
>> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
>> index eeead15..2d78af8 100644
>> --- a/include/linux/mfd/ti_am335x_tscadc.h
>> +++ b/include/linux/mfd/ti_am335x_tscadc.h
>> @@ -116,6 +113,13 @@
>>  #define CNTRLREG_8WIRE		CNTRLREG_AFE_CTRL(3)
>>  #define CNTRLREG_TSCENB		BIT(7)
>>  
>> +#define XPP			STEPCONFIG_XPP
>> +#define XNP			STEPCONFIG_XNP
>> +#define XNN			STEPCONFIG_XNN
>> +#define YPP			STEPCONFIG_YPP
>> +#define YPN			STEPCONFIG_YPN
>> +#define YNN			STEPCONFIG_YNN
> What is that for ? Isn't STEPCONFIG_XPP explicit enough ?

Yeah :P It was added by the original author of the patch, I have no
problem getting rid of it.

> 
> Cheers,
> Samuel.

Sebastian
