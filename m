Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbaGXTLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:11:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440AbaGXTLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:11:48 -0400
Message-ID: <53D15A6B.6030806@nod.at>
Date: Thu, 24 Jul 2014 21:11:39 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>, tomas.winkler@intel.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>	<20140724144725.GA32669@home.goodmis.org>	<20140724105132.3cf221c2@gandalf.local.home>	<yw1x38dqag24.fsf@unicorn.mansr.com>	<CAPDOMVgswyopjGxdRFW-bFRrTcpcNnkY=PqTCT9HbjjA=EZ1iw@mail.gmail.com>	<yw1xy4vi90n6.fsf@unicorn.mansr.com>	<CAPDOMVia0OXydg_hRH0t63xUaxKEkVc6D20vAZiyugkMXAEsJQ@mail.gmail.com>	<yw1xtx669002.fsf@unicorn.mansr.com>	<CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>	<20140724131821.30c4519d@gandalf.local.home>	<CAHLZz12ammMZNAah_eyYePJWorw2AruDAujeNxJHvOF5+Mr7cA@mail.gmail.com>	<20140724134849.4d228f5f@gandalf.local.home>	<CAPDOMVi7cHUAn_1AxJ+tN1c67UqBdLHLC1sJNSA=HUK-WzZCTA@mail.gmail.com>	<CAFLxGvzA4HHL0aJaC0Ypf9_YeL5WW4_eYNToSVG7H43DD2unSg@mail.gmail.com>	<CAPDOMViVAY5cBuwe=nLjnFUHy4_FVUh_9LkChv+vso5w7WVeDA@mail.gmail.com> <CAPDOMVhNaV+Wertp+p361iYS8t-rZmN2nubn9coyrUcgZPcuGw@mail.gmail.com>
In-Reply-To: <CAPDOMVhNaV+Wertp+p361iYS8t-rZmN2nubn9coyrUcgZPcuGw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.07.2014 21:05, schrieb Nick Krause:
> On Thu, Jul 24, 2014 at 2:55 PM, Nick Krause <xerofoify@gmail.com> wrote:
>> On Thu, Jul 24, 2014 at 2:49 PM, Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> On Thu, Jul 24, 2014 at 8:41 PM, Nick Krause <xerofoify@gmail.com> wrote:
>>>> Steve,
>>>> I have programming a lot in other areas just not the kernel.
>>>> You are right through I need to test my code better through.
>>>
>>> Nick,
>>>
>>> let's make a deal.
>>> Take the challenge at http://eudyptula-challenge.org. After you've solved all
>>> tasks we'll accept patches from you.
>>>
>>> --
>>> Thanks,
>>> //richard
>> That's fine,
>> So Sorry :(.
>> Nick
> I sent the challenge a email. Seems that there not replying.

Patience is a virtue.

Thanks,
//richard
