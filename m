Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaETXhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:37:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:31938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaETXhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:37:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,877,1392192000"; 
   d="scan'208";a="542424845"
Message-ID: <537BE72E.8010708@linux.intel.com>
Date: Wed, 21 May 2014 07:37:18 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: sameo@linux.intel.com, linux-kernel@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH 0/4] mfd: Intel SoC Power Management IC
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com> <20140520145507.GU24991@lee--X1>
In-Reply-To: <20140520145507.GU24991@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/20/2014 10:55 PM, Lee Jones wrote:
> On Wed, 14 May 2014, Zhu, Lejun wrote:
> 
>> Devices based on Intel SoC products such as Baytrail have a Power
>> Management IC. In the PMIC there are subsystems for voltage regulation,
>> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
>> Crystal Cove.
>>
>> This series contains common code for these PMICs, and device specific
>> support for Crystal Cove.
>>
>> Lejun Zhu (4):
>>   mfd: intel_soc_pmic: Core driver
>>   mfd: intel_soc_pmic: I2C interface
>>   mfd: intel_soc_pmic: Crystal Cove support
>>   mfd: intel_soc_pmic: Build files
> 
> I'm missing the build files patch.  Can you ensure I was on the
> distribution list please?  Also, what's the reason for splitting the
> files out instead of having one single driver?
> 

I'll resend patch 4/4.

The reason for splitting the files is because there are other models of
such SoC PMIC being worked on. These PMICs will have enough similarity
that we feel it's better to keep separate common code
(intel_soc_pmic_core, intel_soc_pmic_i2c) and model specific code
(intel_soc_pmic_crc and future intel_soc_pmic_xxx).

Best Regards
Lejun

