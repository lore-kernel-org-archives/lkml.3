Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbaGYCrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:47:12 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45843 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbaGYCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:47:11 -0400
Message-ID: <53D1C526.9040307@gmail.com>
Date: Fri, 25 Jul 2014 10:47:02 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: Richard Weinberger <richard@nod.at>,
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
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>	<20140724105132.3cf221c2@gandalf.local.home>	<yw1x38dqag24.fsf@unicorn.mansr.com>	<CAPDOMVgswyopjGxdRFW-bFRrTcpcNnkY=PqTCT9HbjjA=EZ1iw@mail.gmail.com>	<yw1xy4vi90n6.fsf@unicorn.mansr.com>	<CAPDOMVia0OXydg_hRH0t63xUaxKEkVc6D20vAZiyugkMXAEsJQ@mail.gmail.com>	<yw1xtx669002.fsf@unicorn.mansr.com>	<CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>	<20140724131821.30c4519d@gandalf.local.home>	<CAHLZz12ammMZNAah_eyYePJWorw2AruDAujeNxJHvOF5+Mr7cA@mail.gmail.com>	<20140724134849.4d228f5f@gandalf.local.home>	<CAPDOMVi7cHUAn_1AxJ+tN1c67UqBdLHLC1sJNSA=HUK-WzZCTA@mail.gmail.com>	<CAFLxGvzA4HHL0aJaC0Ypf9_YeL5WW4_eYNToSVG7H43DD2unSg@mail.gmail.com>	<CAPDOMViVAY5cBuwe=nLjnFUHy4_FVUh_9LkChv+vso5w7WVeDA@mail.gmail.com>	<CAPDOMVhNaV+Wertp+p361iYS8t-rZmN2nubn9coyrUcgZPcuGw@mail.gmail.com>	<53D15A6B.6030806@nod.at>	<53D1BDCC.5030202@gmail.com> <CAPDOMVhuiSwBs_d6b5qFN2jLwsLAu+_CtaSJH+oG0MxGXmtKOw@mail.gmail.com>
In-Reply-To: <CAPDOMVhuiSwBs_d6b5qFN2jLwsLAu+_CtaSJH+oG0MxGXmtKOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/25/2014 10:20 AM, Nick Krause wrote:
> On Thu, Jul 24, 2014 at 10:15 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>
>> Excuse me, I did not see the patch details, but I guess it is about
>> whether welcome a new member to upstream kernel. For me, I have 3 ideas
>> about it if I am a newbie or a normal kernel developer:
>>
>>  - Do I have enough basic skills for it?
>>
>>     - Do I developed one or more another real world projects with C?
>>       (they are successful projects -- at least, not failure projects)
>>
>>     - Can I construct related develop environments to support what I do?
>>       (e.g. building and testing for upstream kernel)
>>
>>     - Am I familiar the basic working flow about kernel mailing list.
>>       (e.g. format-patch, sending patch, email client configuration...).
>>
>>  - Do I have a correct attitude on it?
>>
>>     - Am I careful enough?
>>       (e.g. if find some details may doubt, try to check and clear them)
>>       (it is always neccessary for all patches)
>>
>>     - Am I try my best for it?
>>       (e.g. when finish coding, try what I can do: build, run and test).
>>       (it is neccessary for most cases)
>>
>>     - Do I have negative effect with others?
>>       (e.g. discourage the newbies, or send spam to other members ...).
>>       (need always try to avoid)
>>
>>  - Do I really love programming, also love open source kernel?
>>
>>     - Do I love it, or I have to do it for another reason?
>>       (I guess, most of gmail members in open source, love programming).
>>
>>     - Do I still love programming if I am discouraged by any members?
>>
>>     - Do I still love open source kernel if discouraged by any members?
>>
>>
> I have most of these skills other then developing real projects in C with other
> developers as other then the kernel I don't have must interest in C outside
> of embedded programming.

OK, thanks. If what you said is true, for me, if you will, please still
continue for open source kernel, but really need be more careful about
the patch you made before send to open mailing list.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
