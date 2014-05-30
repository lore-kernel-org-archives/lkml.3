Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaE3FAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:00:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:38174 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbaE3FAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:00:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,938,1392192000"; 
   d="scan'208";a="548724222"
Message-ID: <53881055.1040109@linux.intel.com>
Date: Fri, 30 May 2014 13:00:05 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 3/3] mfd: intel_soc_pmic: Build files
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com> <1401347968-24410-4-git-send-email-lejun.zhu@linux.intel.com> <20140529114334.GJ1954@lee--X1>
In-Reply-To: <20140529114334.GJ1954@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 7:43 PM, Lee Jones wrote:
>> This patch adds Intel SoC PMIC support to the build files.
> These changes shouldn't really be in a separate patch.
I'll move them into the first (core.c) patch.

Best Regards
Lejun


