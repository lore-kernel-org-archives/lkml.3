Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaDXLvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:51:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:41313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbaDXLvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,918,1389772800"; 
   d="scan'208";a="498849292"
Date: Thu, 24 Apr 2014 14:58:48 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
Message-ID: <20140424115848.GG30677@intel.com>
References: <534B93BA.6020406@linux.intel.com>
 <534BFAAF.3070805@codeaurora.org>
 <534D0370.50108@linux.intel.com>
 <535005BA.1040405@codeaurora.org>
 <5357A80B.8030701@linux.intel.com>
 <5357ACF1.9070206@codeaurora.org>
 <20140423135915.GY30677@intel.com>
 <5357D8CC.3080501@codeaurora.org>
 <20140424063546.GA30677@intel.com>
 <5358F30E.9080402@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358F30E.9080402@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 06:18:38AM -0500, Timur Tabi wrote:
> Westerberg, Mika wrote:
> >>>That is, when the kernel parses the ASL, and it seems a command to
> >>>configure pin #3 to function #4, it calls the local pinctrl driver to do
> >>>that?
> 
> >I'm not aware of ASL code that allows you to do that. Do you have examples?
> 
> No, that's my point.  I was expecting the pinmux functions of the
> pinctrl driver are used by ACPI, but apparently they aren't, and
> that's why I'm asking.

Which functions?

> I'm wondering why a pinctrl driver for an
> ACPI platform should be defining pinmux function groups.  I haven't
> gotten a straight answer to that question.

Are you asking why pinctrl-baytrail.c uses pinctrl_gpio_ranges even if it
is a pretty much standard GPIO driver? Mathias probably can answer that
question better than me.
