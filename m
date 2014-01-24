Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaAXPne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:43:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:33564 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaAXPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:43:33 -0500
Message-ID: <52E28A0F.8020104@windriver.com>
Date: Fri, 24 Jan 2014 10:43:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: delete non-required instances of <linux/init.h>
References: <1390501611-31691-1-git-send-email-paul.gortmaker@windriver.com> <20140124152308.GE19052@arm.com>
In-Reply-To: <20140124152308.GE19052@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-24 10:23 AM, Catalin Marinas wrote:
> On Thu, Jan 23, 2014 at 06:26:51PM +0000, Paul Gortmaker wrote:
>> None of these files are actually using any __init type directives
>> and hence don't need to include <linux/init.h>.  Most are just a
>> left over from __devinit and __cpuinit removal, or simply due to
>> code getting copied from one place to the next.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>
>> [Build tested on today's linux-next ; thanks to Will for the pointer
>>  to a prebuilt toolchain.  Patch to be added to init cleanup series:
>>    http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git   ]
> 
> I assume you are pushing this upstream as part of your cleanup series.

Yes, that is the plan -- ack added, thanks.

P.
--

> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
