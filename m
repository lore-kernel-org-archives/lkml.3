Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbbANJzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:55:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48347 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbANJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:55:46 -0500
Message-ID: <54B63CED.1020603@ti.com>
Date: Wed, 14 Jan 2015 15:24:53 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] arch: arm: common: edma.c:  Remove some unused functions
References: <1417906406-5527-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <54A10868.70001@ti.com>
In-Reply-To: <54A10868.70001@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2014 01:23 PM, Peter Ujfalusi wrote:
> On 12/07/2014 12:53 AM, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> edma_shadow0_read() edma_or_array()
>>
>> This was partially found by using a static code analysis program called cppcheck.
> 
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Queuing for v3.20 through ARM-SoC.

The correct prefix for ARM patches is "ARM: ". I will fix while
applying. Please take care next time on.

Thanks,
Sekhar
