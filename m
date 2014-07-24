Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbaGXRaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:30:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62181 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbaGXRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:30:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140724131821.30c4519d@gandalf.local.home>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<20140724144725.GA32669@home.goodmis.org>
	<20140724105132.3cf221c2@gandalf.local.home>
	<yw1x38dqag24.fsf@unicorn.mansr.com>
	<CAPDOMVgswyopjGxdRFW-bFRrTcpcNnkY=PqTCT9HbjjA=EZ1iw@mail.gmail.com>
	<yw1xy4vi90n6.fsf@unicorn.mansr.com>
	<CAPDOMVia0OXydg_hRH0t63xUaxKEkVc6D20vAZiyugkMXAEsJQ@mail.gmail.com>
	<yw1xtx669002.fsf@unicorn.mansr.com>
	<CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>
	<20140724131821.30c4519d@gandalf.local.home>
Date: Thu, 24 Jul 2014 10:30:51 -0700
Message-ID: <CAHLZz12ammMZNAah_eyYePJWorw2AruDAujeNxJHvOF5+Mr7cA@mail.gmail.com>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nick Krause <xerofoify@gmail.com>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>, paul.gortmaker@windriver.com,
        gang.chen.5i5j@gmail.com, yongjun_wei@trendmicro.com.cn,
        Dan Carpenter <dan.carpenter@oracle.com>, tomas.winkler@intel.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 24 Jul 2014 12:50:31 -0400
> Nick Krause <xerofoify@gmail.com> wrote:

>
>> I am have this discussion with other kernel developers and just
>> because I send out one patch as a newbie like this doesn't mean I
>> don't known C.
>
> It's not just one patch, and I didn't say you don't know C. I said you
> don't understand C enough for kernel development.

And more importantly, stop guessing things are OK and selfishly asking
others to check
your work for you.

If you have not at least _built_ the kernel with your change, and not
_run_ it, and not made
sure that the changed code is being _run_...you are wasting other people's time.

Harvey
