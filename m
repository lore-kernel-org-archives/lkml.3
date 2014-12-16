Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaLPPa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:30:59 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61745 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLPPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:30:56 -0500
Date: Tue, 16 Dec 2014 16:30:48 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Catalin Crenguta <catalin.crenguta@gmail.com>
Cc: "Griffis, Brad" <bgriffis@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicolae Rosia <nicolae.rosia@gmail.com>,
        "R, Vignesh" <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, "Balbi, Felipe" <balbi@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] Touchscreen performance related fixes
Message-ID: <20141216153048.GA16981@localhost.localdomain>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <20141124115116.GA14997@linutronix.de>
 <547C3A95.30605@ti.com>
 <547C3C19.5090501@linutronix.de>
 <547C42FF.5010700@ti.com>
 <CAH=tA9FO5MCzE274thc-NugCNte6WdyC-Rxc6yfnuR=+6_qMbA@mail.gmail.com>
 <548A0125.6040708@linutronix.de>
 <CABH3fy8zCjsxARsqBf9JXOHBkzySdiqifA1KtjnGpJdBY2EikA@mail.gmail.com>
 <912A29987EAE174BA6CF187D7CDFA9CE26FA135A@DLEE08.ent.ti.com>
 <CABH3fy8S1Hb9LK=ZceWgJsNvLbq8pwu00Tcj_0vE4j6QzcO+kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABH3fy8S1Hb9LK=ZceWgJsNvLbq8pwu00Tcj_0vE4j6QzcO+kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:31:47AM +0200, Catalin Crenguta wrote:
> 
> It seems that because the ribbon cable has both the analog and digital
> signals, the analog signals are affected by the digital ones (hence
> the touchscreen was working OK when the display was disabled). Putting
> decoupling capacitors on X+, X-, Y+, Y- reduces the noise and the
> false events disappear.

IOW, the root cause is a design flaw in the BB-View 4.3 Cape?

Thanks,
Richard
