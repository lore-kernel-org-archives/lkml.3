Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3GJIlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:41:49 -0400
Received: from multi.imgtec.com ([194.200.65.239]:8146 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab3GJIlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:41:46 -0400
Message-ID: <51DD1E0F.80101@imgtec.com>
Date: Wed, 10 Jul 2013 09:40:47 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Kees Cook <keescook@chromium.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [RESEND][PATCH] mtd: refactor call to request_module
References: <20130708130512.GA24315@www.outflux.net> <87hag3cdp0.fsf@rustcorp.com.au>
In-Reply-To: <87hag3cdp0.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_10_09_41_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/13 04:10, Rusty Russell wrote:
> Kees Cook <keescook@chromium.org> writes:
>> This reduces the size of the stack frame when calling request_module().
>> Performing the sprintf before the call is not needed.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

I remember reviewing this before, so feel free to add my:

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

