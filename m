Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbaGXQbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:31:12 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59686 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGXQbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <yw1x38dqag24.fsf@unicorn.mansr.com>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<20140724144725.GA32669@home.goodmis.org>
	<20140724105132.3cf221c2@gandalf.local.home>
	<yw1x38dqag24.fsf@unicorn.mansr.com>
Date: Thu, 24 Jul 2014 12:31:05 -0400
Message-ID: <CAPDOMVgswyopjGxdRFW-bFRrTcpcNnkY=PqTCT9HbjjA=EZ1iw@mail.gmail.com>
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

On Thu, Jul 24, 2014 at 12:15 PM, Måns Rullgård <mans@mansr.com> wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
>
>> On Thu, 24 Jul 2014 10:47:25 -0400
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> The three parameters are the number of elements, the size of each individual
>>> element, and then finally the flags used on how to allocate that memory.
>>> I have to say, you did get the flags part correct.
>>>
>>> Now lets look at what you did. For the size you had:
>>
>> That should have read "For the count you had:"
>>
>> Oh well, you get my point anyway.
>
> I have some doubts about the last bit.
>
> --
> Måns Rullgård
> mans@mansr.com


I am have this discussion with other kernel developers and just
because I send out
one patch as a newbie like this doesn't mean I don't known C.
Cheers Nick
