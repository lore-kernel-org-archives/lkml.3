Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3FITV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 15:21:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46465 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3FITV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 15:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E491725F227@PRN-MBX01-3.TheFacebook.com>
References: <CAHp75VdgKDx8vhTcUD5sBLd7aB=39SFxi-ayioZqE6o_AtZkxA@mail.gmail.com>
	<84A937D219C2B44EB8EA44831ACA1E491725F227@PRN-MBX01-3.TheFacebook.com>
Date: Sun, 9 Jun 2013 22:21:27 +0300
Message-ID: <CAHp75Vf4YyudTHZYDACqNA+95JVREw9yZXkY0=3ovHf6G-Bm5A@mail.gmail.com>
Subject: Re: [PATCH] dmatest: add ability to disable pq and xor
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Dan Williams <djbw@fb.com>
Cc: Jon Mason <jon.mason@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 8:11 PM, Dan Williams <djbw@fb.com> wrote:
> On 6/4/13 12:25 AM, "Andy Shevchenko" <andy.shevchenko@gmail.com> wrote:
>>On Tue, Jun 4, 2013 at 2:29 AM, Jon Mason <jon.mason@intel.com> wrote:
>>> On Fri, May 31, 2013 at 11:22:10AM +0300, Andy Shevchenko wrote:

[]

>>>  Since the testing is started immediately upon module
>>> insertion,
>>It used to be so, but nowadays it's true only when dmatest is compiled in.
>>If someone wants to compile in that module they probably want to run
>>stress tests, where XOR and PQ might be useful.
>
> ...and they would want the test selection to be specified on the kernel
> command line.  At least that's how I used compiled in dmatest in the past.

Actually you're right. Better to have it in that case too.

>>My opinion I already shared, new node under debugfs. There is might be
>>a good reason to add a new module parameter as well.
>
> I'm not seeing why debugfs is helpful here.  Just make it a module
> parameter that calls a routine to setup the bit mask.

I'm not objecting against module parameter, though I would like to see
debugfs node for that as well.

--
With Best Regards,
Andy Shevchenko
