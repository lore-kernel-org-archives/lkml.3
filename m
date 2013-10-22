Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3JVKTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:19:11 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:63107 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3JVKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:19:09 -0400
Message-ID: <5266510F.8000300@synopsys.com>
Date: Tue, 22 Oct 2013 15:48:55 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 02/25] smp, alpha: kill SMP single function call
 interrupt
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com> <1378915649-16395-3-git-send-email-liuj97@gmail.com> <52664E7E.6090504@synopsys.com>
In-Reply-To: <52664E7E.6090504@synopsys.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC gmail address, as the othe rone bounced !

On 10/22/2013 03:37 PM, Vineet Gupta wrote:
> Hi Jiang,
> 
> On 09/11/2013 09:37 PM, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
>> similar to smp_call_function_single()" has unified the way to handle
>> single and multiple cross-CPU function calls. Now only one interrupt
>> is needed for architecture specific code to support generic SMP function
>> call interfaces, so kill the redundant single function call interrupt.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> 
> What's the status of this series - seemed useful to me. Are you planning to get it
> merged in 3.13
> 
> -Vineet
> 

