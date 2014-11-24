Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaKXMfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:35:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:38030 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaKXMfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:35:15 -0500
Message-ID: <547325FA.6020004@linutronix.de>
Date: Mon, 24 Nov 2014 13:35:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Vignesh R <vigneshr@ti.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        richardcochran@gmail.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Touchscreen performance related fixes
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com> <20141124115116.GA14997@linutronix.de> <547321A2.6010207@ti.com>
In-Reply-To: <547321A2.6010207@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 01:16 PM, Vignesh R wrote:

> I have tried running both IIO and TSC at the same time. But I have never
> seen WARN_ON() even after running for close to 30 min. Can you send me
> the exact script, so that it will be easy to reproduce?

Sure thing.
- one shell
	evtest /dev/input/event2
- second shell
	./iio-test.sh
  with:

|#!/bin/sh
|
|while [ 1 = 1 ]
|do
|        cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw
|done


the kernel config: https://breakpoint.cc/am335x-config

> 
> Regards
> Vignesh

Sebastian

