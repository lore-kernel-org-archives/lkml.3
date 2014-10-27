Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJ0Ree (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:34:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:60971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJ0Rec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:34:32 -0400
Message-ID: <544E821D.5040004@linutronix.de>
Date: Mon, 27 Oct 2014 18:34:21 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Vignesh R <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>, Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Brad Griffis <bgriffis@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 0/4] Touchscreen performance related fixes
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
In-Reply-To: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 12:08 PM, Vignesh R wrote:
> This series of patches fix TSC defects related to lag in touchscreen

I will try to look this in the next few days. Do we really need #3 (and
then #4)? Given the complexity we have already, is there any benefit by
decreasing this value? Would  someone want to increase it? Can we safely
determine a value which works for everyone?

Sebastian

