Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaDYQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:21:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:52365 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbaDYQVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:21:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="528400662"
Message-ID: <535A8B91.6030903@intel.com>
Date: Fri, 25 Apr 2014 18:21:37 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com> <5357D8CC.3080501@codeaurora.org> <20140424063546.GA30677@intel.com> <5358F30E.9080402@codeaurora.org> <20140424115848.GG30677@intel.com> <53592D04.4040001@codeaurora.org> <20140425074156.GI30677@intel.com> <535A899E.5020801@codeaurora.org>
In-Reply-To: <535A899E.5020801@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2014 6:13 PM, Timur Tabi wrote:
> Westerberg, Mika wrote:
>> If you happen to have pin controller/mux driver that drives that 
>> hardware,
>> I'm sure your pinmux functions gets called.
>
> Actually, I don't think they do.  On a device-tree system, the 
> functions get called automatically by the pinctrl layer when it parses 
> the device tree.  This happens in response to probe, remove, and 
> various power management changes.
>

I would be interested in understanding what exactly the flow is in that 
situation, so care to educate me?  What does the driver do to trigger 
this and what exactly does happen in response to that?

Rafael

