Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCJV74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:59:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53632 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaCJV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:59:54 -0400
Date: Mon, 10 Mar 2014 16:56:58 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/6] rtc: pm8xxx: add support for devicetree
Message-ID: <20140310215658.GM18529@joshc.qualcomm.com>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
 <1394477089-3996-5-git-send-email-joshc@codeaurora.org>
 <20140310134748.dae1b77cfac3df68bd2c1d69@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310134748.dae1b77cfac3df68bd2c1d69@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 01:47:48PM -0700, Andrew Morton wrote:
> On Mon, 10 Mar 2014 13:44:47 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:
> 
> > Add support for describing the PM8921/PM8058 RTC in device tree.
> > 
> > Additionally:
> >    - drop support for describing the RTC using platform data,
> >      as there are no current in tree users who do so.
> >    - make allow_set_time a device-specific flag, instead of mucking
> >      with the rtc_ops
> 
> Is this tested with and without CONFIG_OF?

It's been runtime tested with CONFIG_OF and I ensured it at least built
when !CONFIG_OF, although the drivers useless in that configuration.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
