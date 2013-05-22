Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3EVQ0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:26:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:6763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab3EVQ0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:26:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,722,1363158000"; 
   d="scan'208";a="341768905"
Message-ID: <519CF23D.3050906@intel.com>
Date: Wed, 22 May 2013 09:28:45 -0700
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130315 Icedove/17.0.4
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] gpio-langwell: bugfix and amendments
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 03:20 AM, Andy Shevchenko wrote:
> There is locking bug fix and few amendments. Each commit message verbose
> enoough I think.
>
> Since v2:
>   - apply ACKs
>   - addressed Mika's comment for patch 3/4
>   - append patch 5/5
>
> Since v1:
>   - patch 2/4 ("amend error messages") moved to 4/4
>   - minor fix in patch 3/4 ("use managed ...")
>   - fix patch 4/4 ("amend error messages") to be real amendment
>
> Andy Shevchenko (5):
>    gpio-langwell: initialize lock before usage
>    gpio-langwell: do not use direct access to iomapped memory
>    gpio-langwell: use managed functions pcim_* and devm_*
>    gpio-langwell: amend error messages
>    gpio-langwell: drop away explicit casting
>
>   drivers/gpio/gpio-langwell.c | 117 ++++++++++++++-----------------------------
>   1 file changed, 38 insertions(+), 79 deletions(-)
>
For the whole set:
Acked-by: David Cohen <david.a.cohen@intel.com>
