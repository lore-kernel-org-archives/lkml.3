Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaETXk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:40:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:26122 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaETXkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,877,1392192000"; 
   d="scan'208";a="542425954"
Message-ID: <537BE806.4020004@linux.intel.com>
Date: Wed, 21 May 2014 07:40:54 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: sameo@linux.intel.com, linux-kernel@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH 1/4] mfd: intel_soc_pmic: Core driver
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com> <1400079578-32329-2-git-send-email-lejun.zhu@linux.intel.com> <20140520145827.GV24991@lee--X1>
In-Reply-To: <20140520145827.GV24991@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/20/2014 10:58 PM, Lee Jones wrote:
>> This patch provides the common code for the intel_soc_pmic MFD driver,
>> such as read/write register and set up IRQ.
>>
>> Signed-off-by: Yang, Bin <bin.yang@intel.com>
>> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
>> ---
>>  drivers/mfd/intel_soc_pmic_core.c  | 543 +++++++++++++++++++++++++++++++++++++
>>  drivers/mfd/intel_soc_pmic_core.h  |  83 ++++++
>>  include/linux/mfd/intel_soc_pmic.h |  29 ++
>>  3 files changed, 655 insertions(+)
>>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>>  create mode 100644 include/linux/mfd/intel_soc_pmic.h
> 
> This whole driver needs converting over to regmap.
> 
OK, working on it... Thanks.

Best Regards
Lejun
