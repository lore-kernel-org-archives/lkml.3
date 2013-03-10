Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab3CJNoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:44:23 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:65266 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <1362748282.28241.163.camel@smile>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130307062041.GE13370@intel.com>
	<1362748282.28241.163.camel@smile>
Date: Sun, 10 Mar 2013 21:44:21 +0800
Message-ID: <CAKohpomzM8zcY1gcBqsO7_WXKcNC5p3zhYvAu1cm=Z5WcuT6Vg@mail.gmail.com>
Subject: Re: [PATCH 00/10] dmatest: update the module to use debugfs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 March 2013 21:11, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, 2013-03-07 at 11:50 +0530, Vinod Koul wrote:
>> On Mon, Mar 04, 2013 at 11:09:24AM +0200, Andy Shevchenko wrote:
>> > The first approach to get dmatest module more flexible and easier to play with.
>> > The amount of patches could be reduced, but I would like to get a comments
>> > first on smaller pieces. The entire series creates dmatest.txt file in the
>> > Documentation folder. Similar description is scattered through the commit
>> > messages.
>> >
>> > Module was tested on Intel Medfield and Lynxpoint systems with dw_dmac DMA
>> > controller embedded.
>> Overall the series looks good. I think it can applied in this form as well.
>
> Viresh, so, you are the only one who speaks about reducing amount of
> patches. Do you think is better to either reduce, or leave as is? In
> case of go with smaller amount, could you provide simple scheme which
> patch should be merged with which?

Hi Andy,

I have been damn busy with Linaro Connect last week and couldn't review all
patches too. Probably you can just go ahead with this patchset only as Vinod
is okay with it.

--
viresh
