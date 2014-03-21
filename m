Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbaCUIMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:12:31 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36467 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaCUIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:12:18 -0400
Date: Fri, 21 Mar 2014 08:12:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 6/6] mfd: devicetree: bindings: add pm8xxx RTC
 description
Message-ID: <20140321081212.GB15213@lee--X1>
References: <20140310151807.7274d58d3c50b884585244b6@linux-foundation.org>
 <1394644645-12818-1-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394644645-12818-1-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The PM8xxx family of PMICs contain an RTC.  This RTC is described as a
> subnode of the PM8xxx.  Document these bindings, and replace the pwrkey
> node in the example with the RTC, which is now described in this
> document.
> 
> While we're here, add a short description to the device tree bindings
> describing what the the PM8xxx devices are and how they are expected to
> be used.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
> Andrew-
> 
> Here's a new 6/6.  Like mentioned earlier, this is based on the current MFD
> document that's in Lee's tree pending for 3.15.  It may be best to get yours
> and Rob's Ack and have Lee take it through his tree.

After discussing with Andrew, I think this is better to go through my
tree as you suggested, in order to mitigate any merge conflicts during
the merge window.

Patch applied to the MFD tree with Andrew's Ack, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
