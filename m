Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaCNHbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 03:31:31 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33089 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaCNHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 03:31:29 -0400
Message-ID: <5322B049.1040301@linaro.org>
Date: Fri, 14 Mar 2014 15:31:21 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
References: <20140303142526.GA8517@localhost> <5321618F.3090801@linaro.org> <20140313085341.GC27627@localhost> <5321739B.1000506@linaro.org> <20140314061643.GA28194@localhost> <5322A110.5030405@linaro.org> <20140314064853.GB29349@localhost>
In-Reply-To: <20140314064853.GB29349@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 02:48 PM, Fengguang Wu wrote:
> On Fri, Mar 14, 2014 at 02:26:24PM +0800, Alex Shi wrote:
>> On 03/14/2014 02:16 PM, Fengguang Wu wrote:
>>> Alex,
>>>
>>> Here are the test results for branch alexshi/single-balance
>>
>>
>> Thanks a lot! Fengguang.
>> Is the nex04 machine 4P*8 core * HT? and are a04/a06 atom box?
> 
> nex04 is Nehalem-EX. a04/06 are Atom servers.
> 
>> Would you like to share the machine info for nhm8, nhm-white and xps2?
> 
> They are all 1S Nehalem PC.

thanks for explanation! Are these all the machine launched in testing?

> 
> Thanks,
> Fengguang
> 


-- 
Thanks
    Alex
