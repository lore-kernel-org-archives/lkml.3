Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaKXI6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:58:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:36518 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKXI6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:58:02 -0500
Message-ID: <5472F30A.1000608@linutronix.de>
Date: Mon, 24 Nov 2014 09:57:46 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>, Sekhar Nori <nsekhar@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Vignesh R <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, Robert Nelson <robertcnelson@gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache
 save
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com> <1415941651-28962-4-git-send-email-vigneshr@ti.com> <20141118143005.GF24004@x1> <20141118171240.GB3003@dtor-ws> <546DF2F0.9080405@ti.com> <20141120144028.GB5809@localhost.localdomain> <546F2BA4.4000808@ti.com> <20141121131036.GA18931@localhost.localdomain>
In-Reply-To: <20141121131036.GA18931@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 02:10 PM, Richard Cochran wrote:

> On the BB white using the LCD4 cape and the shipped debian kernel, the
> cursor *does* jump away, but not as often or as far as on the custom
> design I was working with.

This sounds like the ADC is still sampling while the input data becomes
invalid. Usually there is a resistor on the wiper line and the
touchscreen manual says how much it should be at least. Could you
please check if this is properly installed?

> 
> Thanks,
> Richard

Sebastian

