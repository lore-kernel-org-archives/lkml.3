Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab3E1IFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:05:39 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57979 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab3E1IFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:05:36 -0400
MIME-Version: 1.0
In-Reply-To: <519CF23D.3050906@intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<519CF23D.3050906@intel.com>
Date: Tue, 28 May 2013 11:05:35 +0300
Message-ID: <CAHp75VfOAyVvOK+c5ZEM9AYKfB5p=urawqZUKWmYhdttykffpw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] gpio-langwell: bugfix and amendments
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

On Wed, May 22, 2013 at 7:28 PM, David Cohen <david.a.cohen@intel.com> wrote:
> On 05/22/2013 03:20 AM, Andy Shevchenko wrote:
>>
>> There is locking bug fix and few amendments. Each commit message verbose
>> enoough I think.
>>
>> Since v2:
>>   - apply ACKs
>>   - addressed Mika's comment for patch 3/4
>>   - append patch 5/5
>>
>> Since v1:
>>   - patch 2/4 ("amend error messages") moved to 4/4
>>   - minor fix in patch 3/4 ("use managed ...")
>>   - fix patch 4/4 ("amend error messages") to be real amendment
>>
>> Andy Shevchenko (5):
>>    gpio-langwell: initialize lock before usage
>>    gpio-langwell: do not use direct access to iomapped memory
>>    gpio-langwell: use managed functions pcim_* and devm_*
>>    gpio-langwell: amend error messages
>>    gpio-langwell: drop away explicit casting
>>
>>   drivers/gpio/gpio-langwell.c | 117 ++++++++++++++-----------------------------
>>   1 file changed, 38 insertions(+), 79 deletions(-)
>>
> For the whole set:
> Acked-by: David Cohen <david.a.cohen@intel.com>

Linus, do you have any comments on this?

--
With Best Regards,
Andy Shevchenko
