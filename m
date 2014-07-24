Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbaGXQud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:50:33 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54223 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbaGXQuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <yw1xtx669002.fsf@unicorn.mansr.com>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<20140724144725.GA32669@home.goodmis.org>
	<20140724105132.3cf221c2@gandalf.local.home>
	<yw1x38dqag24.fsf@unicorn.mansr.com>
	<CAPDOMVgswyopjGxdRFW-bFRrTcpcNnkY=PqTCT9HbjjA=EZ1iw@mail.gmail.com>
	<yw1xy4vi90n6.fsf@unicorn.mansr.com>
	<CAPDOMVia0OXydg_hRH0t63xUaxKEkVc6D20vAZiyugkMXAEsJQ@mail.gmail.com>
	<yw1xtx669002.fsf@unicorn.mansr.com>
Date: Thu, 24 Jul 2014 12:50:31 -0400
Message-ID: <CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
From: Nick Krause <xerofoify@gmail.com>
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>, paul.gortmaker@windriver.com,
        gang.chen.5i5j@gmail.com, yongjun_wei@trendmicro.com.cn,
        Dan Carpenter <dan.carpenter@oracle.com>, tomas.winkler@intel.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:47 PM, Måns Rullgård <mans@mansr.com> wrote:
> Nick Krause <xerofoify@gmail.com> writes:
>
>> On Thu, Jul 24, 2014 at 12:34 PM, Måns Rullgård <mans@mansr.com> wrote:
>>> Nick Krause <xerofoify@gmail.com> writes:
>>>
>>>> On Thu, Jul 24, 2014 at 12:15 PM, Måns Rullgård <mans@mansr.com> wrote:
>>>>> Steven Rostedt <rostedt@goodmis.org> writes:
>>>>>
>>>>>> On Thu, 24 Jul 2014 10:47:25 -0400
>>>>>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>>>>>
>>>>>>> The three parameters are the number of elements, the size of each individual
>>>>>>> element, and then finally the flags used on how to allocate that memory.
>>>>>>> I have to say, you did get the flags part correct.
>>>>>>>
>>>>>>> Now lets look at what you did. For the size you had:
>>>>>>
>>>>>> That should have read "For the count you had:"
>>>>>>
>>>>>> Oh well, you get my point anyway.
>>>>>
>>>>> I have some doubts about the last bit.
>>>>
>>>> I am have this discussion with other kernel developers and just
>>>> because I send out one patch as a newbie like this doesn't mean I
>>>> don't known C.
>>>
>>> Now I no longer have doubts; I know for certain that the point didn't
>>> get across.
>>
>> I get your point try other things but I talked to other kernel
>> developers and most of them seemed to get this feedback to when they
>> started.
>
> Most kernel devs most certainly did NOT get started by spamming lkml
> with unnecessary and incorrect patches despite being repeatedly told to
> go away and stop wasting everybody's time.
>
> --
> Måns Rullgård
> mans@mansr.com



FIne , I give up. You want me to leave this then I wiil.
Nick
