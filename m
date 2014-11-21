Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaKUVkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:40:17 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41960 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaKUVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:40:14 -0500
Date: Fri, 21 Nov 2014 22:40:05 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Johannes Pointner <johannes.pointner@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Vignesh R <vigneshr@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-iio <linux-iio@vger.kernel.org>, linux-input@vger.kernel.org,
        Robert Nelson <robertcnelson@gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Message-ID: <20141121214005.GA4020@localhost.localdomain>
References: <1415941651-28962-4-git-send-email-vigneshr@ti.com>
 <20141118143005.GF24004@x1>
 <20141118171240.GB3003@dtor-ws>
 <546DF2F0.9080405@ti.com>
 <20141120144028.GB5809@localhost.localdomain>
 <546F2BA4.4000808@ti.com>
 <20141121131036.GA18931@localhost.localdomain>
 <CAJKbBDDVTA+=priRu7sCD=vHrC8AUg4DM3kycuGrqbpF-5FGAA@mail.gmail.com>
 <546F5C27.7040004@ti.com>
 <CAJKbBDD=eYmU=LuViwLPNV=kYCziDQgKjL07bT7og4vsj0Ee7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKbBDD=eYmU=LuViwLPNV=kYCziDQgKjL07bT7og4vsj0Ee7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 07:17:18PM +0100, Johannes Pointner wrote:
> Before the patches were also jumps but I thought it is something
> Vignesh should know. Maybe there is some fix for that too?
> As Richard also noted, it would be nice if ti could let us know how to
> get the delay values right. By trial and error is IMHO not the best
> way.

That is not only an opinion, it is a matter of fact. TI really dropped
the ball on this one. I thought the patch series was a sign they
finally were going to properly address this issue. Wrong again.

The data sheet for the TI part used to have a reference to an app-note
for the touch controller.

      spruh73f page 1154

      The Pen IRQ can only occur if the correct Pen Ctrl bits are high
      (AFE Pen Ctrl bits 6:5 in the TSC_ADC control register) and if
      the correct ground transistor biasing is set in the StepConfig
      [N] Register. Refer to the application notes for the correct
      settings.

I searched high and low for this application note. Then, the data
sheet got revised.

Thanks,
Richard
