Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3FKPmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:42:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:35257 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3FKPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:41:58 -0400
Message-ID: <51B74540.2020608@linutronix.de>
Date: Tue, 11 Jun 2013 17:41:52 +0200
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
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 10/22] mfd/ti_am335x_tscadc: Add DT support
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-11-git-send-email-bigeasy@linutronix.de> <20130611142347.GF29135@zurbaran> <51B73756.5010004@linutronix.de> <20130611150505.GI29135@zurbaran>
In-Reply-To: <20130611150505.GI29135@zurbaran>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 05:05 PM, Samuel Ortiz wrote:
> Hi Sebastian,

Hi Samuel,

> On Tue, Jun 11, 2013 at 04:42:30PM +0200, Sebastian Andrzej Siewior wrote:
>> In the end I would like not to post a patch with "From: != me" and
>> don't make change which the original author did not do. Also dropping
>> their authorship isn't nice. What could we agree on?
> You probably don't want to change authorship unless the final patch is
> really far from the original one. In which case you can change it and
> mention the original author name in the commit log.
> If you have only made a few changes on top of the original patch, please
> say so explicitely in the commit log. Don't bother if we're talking
> about small changes or cosmetic ones. But your commit log has to be
> readable and clear.

Commit 06c9494 on of many examples where cosmetic are recorded. But to
make some progress I rewrite the commit log to resolve this and don't
add anything to the sign-off area.

> Cheers,
> Samuel.

Sebastian
