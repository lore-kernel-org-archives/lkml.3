Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaFLS66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:58:58 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60845 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaFLS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:58:57 -0400
Message-ID: <5399F86B.9080806@windriver.com>
Date: Thu, 12 Jun 2014 13:58:51 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/debug/debug_core.c: Logging clean-up
References: <1402598918-5729-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1402598918-5729-1-git-send-email-fabf@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 01:48 PM, Fabian Frederick wrote:
> -Convert printk( to pr_foo()
> -Add pr_fmt
> -Coalesce formats
>
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>


Thanks.

I looked through all the bits to make sure there were no cases were we
relied on a printk out to the external debug client and everything is
all good.  This even prefixes the KGDB: in one place it was missed as
well as implicitly fixing all the kgdb: -> KGDB: inconsistencies.

The core functionality of kgdb is not changed of course.

I'll put this into the merge queue.

Reviewed-by: Jason Wessel <jason.wessel@windriver.com>

Cheers,
Jason.

