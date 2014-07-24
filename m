Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934385AbaGXSl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:41:56 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:51881 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbaGXSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140724134849.4d228f5f@gandalf.local.home>
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
	<CAHLZz12ammMZNAah_eyYePJWorw2AruDAujeNxJHvOF5+Mr7cA@mail.gmail.com>
	<20140724134849.4d228f5f@gandalf.local.home>
Date: Thu, 24 Jul 2014 14:41:53 -0400
Message-ID: <CAPDOMVi7cHUAn_1AxJ+tN1c67UqBdLHLC1sJNSA=HUK-WzZCTA@mail.gmail.com>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
From: Nick Krause <xerofoify@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
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

On Thu, Jul 24, 2014 at 1:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 24 Jul 2014 10:30:51 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
>
>> On Thu, Jul 24, 2014 at 10:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Thu, 24 Jul 2014 12:50:31 -0400
>> > Nick Krause <xerofoify@gmail.com> wrote:
>>
>> >
>> >> I am have this discussion with other kernel developers and just
>> >> because I send out one patch as a newbie like this doesn't mean I
>> >> don't known C.
>> >
>> > It's not just one patch, and I didn't say you don't know C. I said you
>> > don't understand C enough for kernel development.
>>
>> And more importantly, stop guessing things are OK and selfishly asking
>> others to check
>> your work for you.
>>
>> If you have not at least _built_ the kernel with your change, and not
>> _run_ it, and not made
>> sure that the changed code is being _run_...you are wasting other people's time.
>>
>
> Nick,
>
> Just to bring Harvey's email here in perspective. I mentioned in my
> previous email that most of us are overworked. We don't have time to
> teach you if your patches are correct or not. By saying, "I'll just
> write the code and you tell me if it's correct, and test it for me" is
> like telling someone "Here's a lawn mower, now go mow my lawn".
>
> We like it if people put effort into their work and are confident
> themselves that they have the right code or not. There's enough
> reviewing of patches to do from people that put that effort in, that
> there's no time to review patches from people that don't know if their
> work or not.
>
> Cheers,
>
> -- Steve

Steve,
I have programming a lot in other areas just not the kernel.
You are right through I need to test my code better through.
Cheers Nick
