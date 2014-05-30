Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaE3FB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:01:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:11902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaE3FB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:01:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,938,1392192000"; 
   d="scan'208";a="548724714"
Message-ID: <53881097.6060506@linux.intel.com>
Date: Fri, 30 May 2014 13:01:11 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 2/3] mfd: intel_soc_pmic: Crystal Cove support
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com> <1401347968-24410-3-git-send-email-lejun.zhu@linux.intel.com> <20140529114921.GK1954@lee--X1>
In-Reply-To: <20140529114921.GK1954@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 7:49 PM, Lee Jones wrote:
> On Thu, 29 May 2014, Zhu, Lejun wrote:
> 
>> This patch provides chip-specific support for Crystal Cove. Crystal
>> Cove is the PMIC in Baytrail-T platform.
(...)
>> +enum crystal_cove_irq {
>> +	PWRSRC_IRQ = 0,
>> +	THRM_IRQ,
>> +	BCU_IRQ,
>> +	ADC_IRQ,
>> +	CHGR_IRQ,
>> +	GPIO_IRQ,
>> +	VHDMIOCP_IRQ
>> +};
> 
> I can't help thinking that these should be nice clear #defines
> 
> #define CRYSTAL_COVE_IRQ_PWSRC 		0
> ...
> #define CRYSTAL_COVE_IRQ_VHDMIOCP	6
> 

Sure. I'll fix it.

Best Regards
Lejun

