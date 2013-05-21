Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3EURtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:49:18 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59299 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3EURtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <519BAD99.9020007@intel.com>
References: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<519BAD99.9020007@intel.com>
Date: Tue, 21 May 2013 20:49:14 +0300
Message-ID: <CAHp75VdTVKnR8chYRPrLea_PbbHQy3tbHDwXpVn9=f6wfkoyNw@mail.gmail.com>
Subject: Re: [PATCH 0/4] gpio-langwell: bugfix and amendments
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: David Cohen <david.a.cohen@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 8:23 PM, David Cohen <david.a.cohen@intel.com> wrote:
> On 05/21/2013 03:33 AM, Andy Shevchenko wrote:
>>
>> There is locking bug fix and few amendments. Each commit message verbose
>> enoough I think.
>>
>> Andy Shevchenko (4):
>>    gpio-langwell: initialize lock before usage
>>    gpio-langwell: amend error messages
>>    gpio-langwell: do not use direct access to iomapped memory
>>    gpio-langwell: use managed functions pcim_* and devm_*
>
>
> I wonder if you should rebase those patches on top of this one:
> https://patchwork.kernel.org/patch/2527431/

I actually made my patchset on top of that one.
I think I have to fix patch 2/4 here to call that as real amendment.

--
With Best Regards,
Andy Shevchenko
