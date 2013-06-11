Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3FKOfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:35:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:34731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3FKOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:34:59 -0400
Message-ID: <51B7358D.7000605@linutronix.de>
Date: Tue, 11 Jun 2013 16:34:53 +0200
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
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-2-git-send-email-bigeasy@linutronix.de> <20130611142336.GE29135@zurbaran>
In-Reply-To: <20130611142336.GE29135@zurbaran>
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

>> Therefore this patch removes regmap part of the driver.
> NAK. Using regmap is better than open coding your register accesses, and
> the children not using this API is not a reason for the MFD driver to do
> the same.

There is no advantage over using regmap in the first place. It goes
through a few layers, uses no caching because almost all registers are
volatile and this is a direct bus. In the end it complicates more than
it helps.

> 
> Cheers,
> Samuel.
> 

Sebastian
