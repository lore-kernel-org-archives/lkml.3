Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbaKUMLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:11:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38377 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaKUMLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:11:43 -0500
Message-ID: <546F2BA4.4000808@ti.com>
Date: Fri, 21 Nov 2014 17:40:12 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
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
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Robert Nelson <robertcnelson@gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache
 save
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com> <1415941651-28962-4-git-send-email-vigneshr@ti.com> <20141118143005.GF24004@x1> <20141118171240.GB3003@dtor-ws> <546DF2F0.9080405@ti.com> <20141120144028.GB5809@localhost.localdomain>
In-Reply-To: <20141120144028.GB5809@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 08:10 PM, Richard Cochran wrote:
> On Thu, Nov 20, 2014 at 07:26:00PM +0530, Sekhar Nori wrote:
>> I tested this using lcd7 cape connected to beaglebone black. The latest
>> kernel I could find on this board was a TI BSP based v3.14 kernel. So I
>> had to port these patches to that kernel. Cc Robert Nelson to see if he
>> knows about a more recent kernel supporting that cape.
> 
> What is missing from mainline for the black?
> 
> (I thought it was fully supported by now.)

Black is supported, but LCD7 cape is not.

>  
>> I did not see any breakage with these patches applied although I did not
>> see any noticeable performance improvement as well.
> 
> So, the jumping on pen-up persists, right?  That means the patch
> series does not provide a general fix for that issue.

Not sure how to reproduce the jumping on pen-up. I was able to draw
circles, sign my name and actually today I wrote up the whole English
alphabet on the screen. Picture here.

https://drive.google.com/file/d/0ByWLwvGx8MeyVF9CTlhHU0FHMFk/view?usp=sharing

Is there any particular pattern you want me to test with?

I would still like to test with a more recent kernel on LCD7 cape. So,
if anyone has ideas (other than I porting the LCD7 support) please let
me know.

Thanks,
Sekhar
