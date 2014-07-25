Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbaGYDa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 23:30:59 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59918 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbaGYDa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 23:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <53D1CD4C.90507@gmail.com>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<CAPDOMVia0OXydg_hRH0t63xUaxKEkVc6D20vAZiyugkMXAEsJQ@mail.gmail.com>
	<yw1xtx669002.fsf@unicorn.mansr.com>
	<CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>
	<20140724131821.30c4519d@gandalf.local.home>
	<CAHLZz12ammMZNAah_eyYePJWorw2AruDAujeNxJHvOF5+Mr7cA@mail.gmail.com>
	<20140724134849.4d228f5f@gandalf.local.home>
	<CAPDOMVi7cHUAn_1AxJ+tN1c67UqBdLHLC1sJNSA=HUK-WzZCTA@mail.gmail.com>
	<CAFLxGvzA4HHL0aJaC0Ypf9_YeL5WW4_eYNToSVG7H43DD2unSg@mail.gmail.com>
	<CAPDOMViVAY5cBuwe=nLjnFUHy4_FVUh_9LkChv+vso5w7WVeDA@mail.gmail.com>
	<CAPDOMVhNaV+Wertp+p361iYS8t-rZmN2nubn9coyrUcgZPcuGw@mail.gmail.com>
	<53D15A6B.6030806@nod.at>
	<53D1BDCC.5030202@gmail.com>
	<CAPDOMVhuiSwBs_d6b5qFN2jLwsLAu+_CtaSJH+oG0MxGXmtKOw@mail.gmail.com>
	<53D1C526.9040307@gmail.com>
	<CAPDOMVhZNVOjCFYa4oJCL2rSRjXPjEgcQC42w_LGXHubYmDyYA@mail.gmail.com>
	<53D1CA70.60301@gmail.com>
	<CAPDOMVjCmjM2QeXCx+TK8wk3LXiCq+NKK7ami6n2HP0gO0YGBg@mail.gmail.com>
	<53D1CD4C.90507@gmail.com>
Date: Thu, 24 Jul 2014 23:30:56 -0400
Message-ID: <CAPDOMViMDiWONkk=TMu-U6ugKr4uiPk_km=-z-dO_0MwxYJ03w@mail.gmail.com>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
From: Nick Krause <xerofoify@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>, tomas.winkler@intel.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:21 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>
>
> On 07/25/2014 11:13 AM, Nick Krause wrote:
>> On Thu, Jul 24, 2014 at 11:09 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>>
>>>
>>> On 07/25/2014 10:53 AM, Nick Krause wrote:
>>>> On Thu, Jul 24, 2014 at 10:47 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>>>>
>>>>>
>>>>> On 07/25/2014 10:20 AM, Nick Krause wrote:
>>>>>> On Thu, Jul 24, 2014 at 10:15 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>>>>>>
>>>>>>> Excuse me, I did not see the patch details, but I guess it is about
>>>>>>> whether welcome a new member to upstream kernel. For me, I have 3 ideas
>>>>>>> about it if I am a newbie or a normal kernel developer:
>>>>>>>
>>>>>>>  - Do I have enough basic skills for it?
>>>>>>>
>>>>>>>     - Do I developed one or more another real world projects with C?
>>>>>>>       (they are successful projects -- at least, not failure projects)
>>>>>>>
>>>>>>>     - Can I construct related develop environments to support what I do?
>>>>>>>       (e.g. building and testing for upstream kernel)
>>>>>>>
>>>>>>>     - Am I familiar the basic working flow about kernel mailing list.
>>>>>>>       (e.g. format-patch, sending patch, email client configuration...).
>>>>>>>
>>>>>>>  - Do I have a correct attitude on it?
>>>>>>>
>>>>>>>     - Am I careful enough?
>>>>>>>       (e.g. if find some details may doubt, try to check and clear them)
>>>>>>>       (it is always neccessary for all patches)
>>>>>>>
>>>>>>>     - Am I try my best for it?
>>>>>>>       (e.g. when finish coding, try what I can do: build, run and test).
>>>>>>>       (it is neccessary for most cases)
>>>>>>>
>>>>>>>     - Do I have negative effect with others?
>>>>>>>       (e.g. discourage the newbies, or send spam to other members ...).
>>>>>>>       (need always try to avoid)
>>>>>>>
>>>>>>>  - Do I really love programming, also love open source kernel?
>>>>>>>
>>>>>>>     - Do I love it, or I have to do it for another reason?
>>>>>>>       (I guess, most of gmail members in open source, love programming).
>>>>>>>
>>>>>>>     - Do I still love programming if I am discouraged by any members?
>>>>>>>
>>>>>>>     - Do I still love open source kernel if discouraged by any members?
>>>>>>>
>>>>>>>
>>>>>> I have most of these skills other then developing real projects in C with other
>>>>>> developers as other then the kernel I don't have must interest in C outside
>>>>>> of embedded programming.
>>>>>
>>>>> OK, thanks. If what you said is true, for me, if you will, please still
>>>>> continue for open source kernel, but really need be more careful about
>>>>> the patch you made before send to open mailing list.
>>>>>
>>>>>
>>>>> Thanks.
>>>>> --
>>>>> Chen Gang
>>>>>
>>>>> Open, share, and attitude like air, water, and life which God blessed
>>>>
>>>> Chen ,
>>>> Thanks for helping me out here :). The true through is I don't known how to
>>>> build test correctly as a newb and thought it was better just to avoid it(stupid
>>>> me). I would like to known how to do this and if there is any way I can help you
>>>> guys out , please let me known :). I don't want to be avoided I am honestly here
>>>> to help make your life easier.
>>>
>>> Excuse me, my English is not quite well, I do not understand what you
>>> said, I guess your meaning is "not familiar with how to build and test
>>> upstream kernel" If what I guess is incorrect, please let me know.
>>>
>>> There are some books or some related web links for building and test
>>> kernel, they are not quite difficult to get (please google search).
>>>
>>> I guess, it is necessary to reference these information and construct
>>> related develop environments to support what you want to do next.
>>>
>>>
>>> By the way, excuse me, today I have to do some other things firstly, so
>>> maybe my next email reply will be late (may tomorrow, or the day after
>>> tomorrow).
>>>
>>>
>>> Thanks.
>>> --
>>> Chen Gang
>>>
>>> Open, share, and attitude like air, water, and life which God blessed
>>
>> That's what I meant. If you can sent me a link to how to do build testing
>> that would be great :).
>
> Please read README at the root directory of kernel source, also
> "./Documents" contents many valuable information. And try google search
> for additional information.
>
> Try to accomplish them by yourself, that will let yourself improved with
> efficiency.
>
> Thanks.
> --
> Chen Gang
>
> Open, share, and attitude like air, water, and life which God blessed

That seems to be the issue with my programming here.
Nick
