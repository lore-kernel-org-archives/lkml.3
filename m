Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaEGD6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:58:52 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64868 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaEGD6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:58:50 -0400
Message-ID: <5369AF6D.9060509@huawei.com>
Date: Wed, 7 May 2014 11:58:37 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: sanil kumar <sanil.kumar@huawei.com>, <linuxarm@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IEhVTEsgbWFuYWdlbWVudCBwb2xpY3kgYW5kIHVzZXIgbWFudWE=?=
 =?UTF-8?B?bC12MS40Ly9SZTog5pS26ZuG5LqG5aSn5a6255qE5oSP6KeB77yM5L+u5pS55LqG?=
 =?UTF-8?B?6YOo5YiG5YiG5pSv566h55CG44CCLy/mrKfmi4nnu5/kuIDlhoXmoLjniYjmnKw=?=
 =?UTF-8?B?566h55CG562W55Wl5Lul5Y+K5pON5L2c5omL5YaMLy9SZTog56Gu6K6k5LiA5LiL?=
 =?UTF-8?B?5ZCE5L2N6KaB6K6/6Zeu5ZOq5Lqb5LuT5bqTIC8vIFJlOiDor7flkITkvY3mj5A=?=
 =?UTF-8?B?5L6b6K6/6ZeuIGdpdCDmnI3liqHlmajnmoTlhazpkqUgLy8gUmU6IEZ3OiDpnIA=?=
 =?UTF-8?B?6KaB5Yqg5YWl5Lit6L2v5YaF6YOoZ2l05Lul5Y+KbWFpbGxpc3TnmoTlkI3ljZU=?=
References: <OF27FF9D0B.06B65A5B-ON48257CD0.002EA3A1-48257CD0.002F3FF0@LocalDomain> <OF384E7FE5.F83418F8-ON48257CD0.00339B82-48257CD0.00342759@notesmail.huawei.com.cn> <5368C270.9030208@huawei.com> <5368C46F.7080406@huawei.com> <5368D34F.5070301@huawei.com> <53699E44.4050400@huawei.com>
In-Reply-To: <53699E44.4050400@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/7 10:45, Li Zefan wrote:
> On 2014/5/6 20:19, Ding Tianhong wrote:
>> On 2014/5/6 19:15, sanil kumar wrote:
>>> On 5/6/2014 4:37 PM, Ding Tianhong wrote:
>>>> On 2014/5/6 17:29, maobibo 00177601 wrote:
>>>>> Hi Tianhong,
>>>>>
>>>>> I have two questions about the HULK
>>>>>    1) When we get kernel from HULK such as euler-arm64branch, if there are some bugs in the branch and we report this bug,
>>>>>       will CSI team be responsible to fix the bug?
>>>>
>>>> If the bug is exist in the kernel and not from third-party application just like Customer's own drivers, I have to say "YES", we
>>>> will fix them and upstream them.
>>>>
>>>>
>>>>>
>>>>>    2) When we submit a patch to HULK and if it is accepted, will CSI team be response to push it to upstream mainline branch?
>>>>>
>>>>
>>>>
>>>> If this patch is developed by yourself, and only for features or capabilities, you have to upstream the patch yourself.
>>> If we don't have strategy to handle this, we may end up facing issues with long term maintenance of HULK. Do you see this risk?
>>> This can be applicable to any patches whether its coming from external or internal members of CSI.
>>
>> Hi sanil:
>>
>> Yes, I got your opinion, and we already face this problem several times, in principle everyone should be responsible for their own code,
>> I hope every patch in our HULK repository could be applied to linux mainline tree, the CSI should help them to make the code more in line
>> with the community standard, it is a relationship, not a obligations.
>>
>> So I think we should discuss the strategy together, In my opinion, there is no external or internal members of CSI, everyone is a
>> kernel developer, if the code or patch has a good reason to upstream to the linux mainline tree, the author should have responsibility to handle
>> this work, if the author met some problem and could not handle this alone, our HULK team should help him to upstream, this is a great team should do.
>>
>> Hi zefan: 
>> As a senior expert, can you give us more suggestion to handle this, thanks.
>>
> 
> As I'm not working on arm64, I don't know how you guys have been co-operating. :)
> 
> Can't we learn from the development process of LSK?
> 
> How about we obey a rule "upstream first". Patches are sent to our internal mailing
> list for review, and then they should be sent to the community. They won't be accepted
> by HULK util they are merged into mainline, or you have to explain why they aren't
> accepted and why it's ok for HULK to merge them though.
> 
> The principal is we should all work on upstreaming our code. We can't ask HULK to
> do all the upstream work.
> 
> The community doesn't like delegation, which means it should be the author that submits
> the patch. However this is not a strict requirement. If you can fully understand the
> patch and you're able to answer people's comments on this patch when it's posted, you
> may submit it given you've got the autoher's approval.
> 

Hi zefan:

Thanks for your suggestion, I think it is more clear and reasonable, if we need deeper discussion, the branch maintainer for CHI and Hisilicon need to enter
this discussion.

Hi guozhu, wangwei:

I need to know the branch maintainer for your department, please tell me the name and then I could discussion with them for the strategy and perfect the HULK document,
thanks for any suggestion.

Regards
Ding

> btw what does CSI mean?
> 

Central Software Institute :)

> 



> .
> 


