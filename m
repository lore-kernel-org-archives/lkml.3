Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3EURXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:23:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:55847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3EURXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:23:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,715,1363158000"; 
   d="scan'208";a="340926110"
Message-ID: <519BAD99.9020007@intel.com>
Date: Tue, 21 May 2013 10:23:37 -0700
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] gpio-langwell: bugfix and amendments
References: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Thanks for the patches. :)

On 05/21/2013 03:33 AM, Andy Shevchenko wrote:
> There is locking bug fix and few amendments. Each commit message verbose
> enoough I think.
>
> Andy Shevchenko (4):
>    gpio-langwell: initialize lock before usage
>    gpio-langwell: amend error messages
>    gpio-langwell: do not use direct access to iomapped memory
>    gpio-langwell: use managed functions pcim_* and devm_*

I wonder if you should rebase those patches on top of this one:
https://patchwork.kernel.org/patch/2527431/

Maybe Linux Walleij knows better.

Br, David Cohen

>   drivers/gpio/gpio-langwell.c | 93 +++++++++++++-------------------------------
>   1 file changed, 28 insertions(+), 65 deletions(-)
>

