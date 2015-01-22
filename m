Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbbAVLim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:38:42 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:48427 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbbAVLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:38:40 -0500
Message-ID: <54C0E13B.2070400@nexus-software.ie>
Date: Thu, 22 Jan 2015 11:38:35 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, dvhart@infradead.org,
        andy.shevchenko@gmail.com, boon.leong.ong@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie> <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1501221220530.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501221220530.5526@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 11:24, Thomas Gleixner wrote:
> On Wed, 21 Jan 2015, Bryan O'Donoghue wrote:
>>   arch/x86/Kconfig           |  25 ++
>>   arch/x86/Kconfig.debug     |  13 +
>>   arch/x86/include/asm/imr.h |  60 ++++
>>   arch/x86/kernel/Makefile   |   1 +
>>   arch/x86/kernel/imr.c      | 681 +++++++++++++++++++++++++++++++++++++++++++++
>
> Can we please stop to dump random stuff into x86/kernel?
>
> x86/platform ... would be a proper place for this.
>
> Thanks,
>
> 	tglx
>

Hi Thomas.

The IMR registers live in the north cluster of the SoC which is why I 
thought arch/x86/kernel would be the best place for this code.

That said, there's no technical reason we couldn't move this code to

drivers/platform/x86/intel_qrk_imr.c

Darren - would that be acceptable to you ?


