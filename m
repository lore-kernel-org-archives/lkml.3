Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3K0Pks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:40:48 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42096 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3K0Pkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:40:46 -0500
Message-ID: <52961272.7010400@gmail.com>
Date: Wed, 27 Nov 2013 23:40:34 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com> <1382109602-27432-3-git-send-email-liuj97@gmail.com> <20131030001245.GB25346@mudshark.cambridge.arm.com> <527671E9.8040704@gmail.com> <20131127122053.GG9032@mudshark.cambridge.arm.com>
In-Reply-To: <20131127122053.GG9032@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 08:20 PM, Will Deacon wrote:
> Hi Jiang Liu,
> 
> On Sun, Nov 03, 2013 at 03:55:21PM +0000, Jiang Liu wrote:
>> On 10/30/2013 08:12 AM, Will Deacon wrote:
>>> If I try and email you at your Huawei address, I get a bounce from the mail
>>> server. Is that expected? If so, it's not very helpful from a commit log
>>> perspective if you use that address as the author on your patches.
>>>
>> Hi Will,
>> 	Sorry for the inconvenience. I have left Huawei recently and
>> have had a vacation last two weeks. I will use my gmail account next
>> time.
> 
> I appreciate that you're probably not being paid to look at this anymore,
> but have you had a chance to address the comments I made on version 5 of
> this series? As far as I'm concerned, this is almost ready for merging and
> I'd love to see it get in for 3.14!
> 
> It would be a real shame if this ended up getting dropped...
Hi Will,
	Thanks for reminder!
	I have changed the code according to review comments,
but I'm having troubles to find a real hardware platform to test
the new code since I left Huawei. I will try to figure out a way
to test the code by contacting ex-teammember at Huawei.
	Hope it could catch the of 3.14 merging window.
Cheers,
Gerry
> 
> Cheers,
> 
> Will
> 

