Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaDYHe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:34:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:12923 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaDYHeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,925,1389772800"; 
   d="scan'208";a="423720586"
Date: Fri, 25 Apr 2014 10:41:57 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
Message-ID: <20140425074156.GI30677@intel.com>
References: <534D0370.50108@linux.intel.com>
 <535005BA.1040405@codeaurora.org>
 <5357A80B.8030701@linux.intel.com>
 <5357ACF1.9070206@codeaurora.org>
 <20140423135915.GY30677@intel.com>
 <5357D8CC.3080501@codeaurora.org>
 <20140424063546.GA30677@intel.com>
 <5358F30E.9080402@codeaurora.org>
 <20140424115848.GG30677@intel.com>
 <53592D04.4040001@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53592D04.4040001@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:25:56AM -0500, Timur Tabi wrote:
> On 04/24/2014 06:58 AM, Westerberg, Mika wrote:
> >>>No, that's my point.  I was expecting the pinmux functions of the
> >>>pinctrl driver are used by ACPI, but apparently they aren't, and
> >>>that's why I'm asking.
> 
> >Which functions?
> 
> The functions in struct pinmux_ops, like get_function_groups.  Will
> these functions ever be called on an ACPI system?

Well, if you have an ACPI system (like normal PC) it is perfectly fine to
have pin controller/mux hardware there which is not dependent at all on
ACPI.

If you happen to have pin controller/mux driver that drives that hardware,
I'm sure your pinmux functions gets called.
