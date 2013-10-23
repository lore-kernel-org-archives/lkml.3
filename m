Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3JWJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:28:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:62593 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JWJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:28:23 -0400
Message-ID: <526796AC.9000207@windriver.com>
Date: Wed, 23 Oct 2013 17:28:12 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v5][PATCH 6/6] book3e/kgdb: Fix a single stgep case of lazy
 IRQ
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>	 <1371724110-8250-7-git-send-email-tiejun.chen@windriver.com> <1382139147.7979.934.camel@snotra.buserror.net>
In-Reply-To: <1382139147.7979.934.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 07:32 AM, Scott Wood wrote:
> On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
>> When we're in kgdb_singlestep(), we have to work around to get
>> thread_info by copying from the kernel stack before calling
>> kgdb_handle_exception(), then copying it back afterwards.
>>
>> But for PPC64, we have a lazy interrupt implementation. So after
>> copying thread info frome kernle stack, if we need to replay an
>> interrupt, we shouldn't restore that previous backup thread info
>> to make sure we can replay an interrupt lately with a proper
>> thread info.
>
> Explain why copying it would be a problem.
>

This would be gone away in next version as well :)

Thanks,

Tiejun

