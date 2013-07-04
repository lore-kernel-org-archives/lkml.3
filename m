Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3GDLPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:15:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60306 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3GDLPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:15:15 -0400
Message-ID: <51D5592F.6050208@ti.com>
Date: Thu, 4 Jul 2013 16:44:55 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [PATCH 04/22] input/ti_am33x_tsc: Order of TSC wires, made configurable
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-5-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1370950268-7224-5-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2013 5:00 PM, Sebastian Andrzej Siewior wrote:
> From: "Patil, Rachna" <rachna@ti.com>
> 
> The current driver expected touchscreen input
> wires(XP,XN,YP,YN) to be connected in a particular order.
> Making changes to accept this as platform data

The platform data part of this driver will never get used since it is
used on DT-only platforms (and future platforms will all be DT-only).
You should get rid of it as it will save you some code.

Thanks,
Sekhar
