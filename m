Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3JWJ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:27:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:62202 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3JWJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:27:34 -0400
Message-ID: <5267967A.6010707@windriver.com>
Date: Wed, 23 Oct 2013 17:27:22 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v5][PATCH 3/6] book3e/kgdb: update thread's dbcr0
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>	 <1371724110-8250-4-git-send-email-tiejun.chen@windriver.com> <1382137030.7979.914.camel@snotra.buserror.net>
In-Reply-To: <1382137030.7979.914.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 06:57 AM, Scott Wood wrote:
> On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
>> gdb always need to generate a single step properly to invoke
>> a kgdb state. But with lazy interrupt, book3e can't always
>> trigger a debug exception with a single step since the current
>> is blocked for handling those pending exception, then we miss
>> that expected dbcr configuration at last to generate a debug
>> exception.
>
> What do you mean by "the current is blocked"?  Could you explain more
> clearly what lazy EE has to do with MSR_DE and DBCR0?
>

I will go another path to make sure the lazy EE doesn't affect KGDB, so please 
see next version.

Thanks,

Tiejun

