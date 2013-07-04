Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3GDLd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:33:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:40542 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3GDLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:33:26 -0400
Message-ID: <51D55D80.6080803@linutronix.de>
Date: Thu, 04 Jul 2013 13:33:20 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 04/22] input/ti_am33x_tsc: Order of TSC wires, made configurable
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-5-git-send-email-bigeasy@linutronix.de> <51D5592F.6050208@ti.com>
In-Reply-To: <51D5592F.6050208@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 01:14 PM, Sekhar Nori wrote:
> 
> On 6/11/2013 5:00 PM, Sebastian Andrzej Siewior wrote:
>> From: "Patil, Rachna" <rachna@ti.com>
>>
>> The current driver expected touchscreen input
>> wires(XP,XN,YP,YN) to be connected in a particular order.
>> Making changes to accept this as platform data
> 
> The platform data part of this driver will never get used since it is
> used on DT-only platforms (and future platforms will all be DT-only).
> You should get rid of it as it will save you some code.

If you follow the series you will notice that the platform bits are
removed later. Should I have overlooked something please say so.

> 
> Thanks,
> Sekhar
> 

Sebastian
