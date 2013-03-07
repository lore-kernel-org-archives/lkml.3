Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3CGIh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:37:56 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:63524 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3CGIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:37:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130307061143.GD13370@intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-7-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130305092649.GD28136@intel.com>
	<1362479804.28241.114.camel@smile>
	<20130305103525.GB13370@intel.com>
	<CAHp75Vc6KmPQYjSx5m+gEBCe4g2tRgEPKyg4hZx9ytk99pB7Qw@mail.gmail.com>
	<20130307061143.GD13370@intel.com>
Date: Thu, 7 Mar 2013 10:37:53 +0200
Message-ID: <CAHp75VeOqadXJiYH5U0Wn2bqgpBF8Jp=J5aFO1ti5ZxoZ26GVg@mail.gmail.com>
Subject: Re: [PATCH 06/10] dmatest: run test via debugfs
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, missed Cc list in the middle. Return it back and thus leave a full
message below.

On Thu, Mar 7, 2013 at 8:11 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Mar 06, 2013 at 05:53:20PM +0200, Andy Shevchenko wrote:
>> >> > How do you terminate a test? Esp if you have started bunch of concurent tests
>> >> > and want to terminate one of them...
>> >>
>> >> There is only one test in progress is possible.
>> > Wasnt the idea to run concurrent tests, or I read wrongly...
>>
>> No, the idea was to run different tests sequentially from userspace
>> withou loading/unloading
>> module each time and with storage support for the results that could
>> be parsed automatically.
>>
>> Running concurrent tests is a good feature to be in TODO list.
> I dont think anything in code prevents you from doing so. Only issue woud
> triggering bunch of tests together and killing them
>
> What we could build on this is
> - configuringa  test but running later (so that we configure bunch of tests and
>   then start them later, when ready)
> - killing a specific task

As it's not our main goal, I prefer leave in TODO this for now.
debugfs approach opens
a wide directions to get nice QA tool for DMA drivers.

> Both of these would need some 'cookie' for tests or some otehr scheme to
> identify a test

True. It could be just a idr mapping like integer # <-> test case parameters.
I think most important feature is to add  the timestamps to the results.

-- 
With Best Regards,
Andy Shevchenko
