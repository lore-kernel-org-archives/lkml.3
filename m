Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3CKIMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:12:10 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:49669 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3CKIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomzM8zcY1gcBqsO7_WXKcNC5p3zhYvAu1cm=Z5WcuT6Vg@mail.gmail.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130307062041.GE13370@intel.com>
	<1362748282.28241.163.camel@smile>
	<CAKohpomzM8zcY1gcBqsO7_WXKcNC5p3zhYvAu1cm=Z5WcuT6Vg@mail.gmail.com>
Date: Mon, 11 Mar 2013 10:12:07 +0200
Message-ID: <CAHp75VcN-W3B+pfHDSFwvQuEidYD81JagNNkrbHXVj7wkaNmOA@mail.gmail.com>
Subject: Re: [PATCH 00/10] dmatest: update the module to use debugfs
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 3:44 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 8 March 2013 21:11, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Thu, 2013-03-07 at 11:50 +0530, Vinod Koul wrote:
>>> On Mon, Mar 04, 2013 at 11:09:24AM +0200, Andy Shevchenko wrote:
>>> > The first approach to get dmatest module more flexible and easier to play with.
>>> > The amount of patches could be reduced, but I would like to get a comments
>>> > first on smaller pieces. The entire series creates dmatest.txt file in the
>>> > Documentation folder. Similar description is scattered through the commit
>>> > messages.
>>> >
>>> > Module was tested on Intel Medfield and Lynxpoint systems with dw_dmac DMA
>>> > controller embedded.
>>> Overall the series looks good. I think it can applied in this form as well.
>>
>> Viresh, so, you are the only one who speaks about reducing amount of
>> patches. Do you think is better to either reduce, or leave as is? In
>> case of go with smaller amount, could you provide simple scheme which
>> patch should be merged with which?

> I have been damn busy with Linaro Connect last week and couldn't review all
> patches too. Probably you can just go ahead with this patchset only as Vinod
> is okay with it.

It seems Vinod is on vacation. So, take your time to finish review. I
appreciate it.

-- 
With Best Regards,
Andy Shevchenko
