Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3INQtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:49:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47532 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3INQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:49:45 -0400
Message-ID: <5234938E.7010809@infradead.org>
Date: Sat, 14 Sep 2013 09:49:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: benh@kernel.crashing.org, rob@landley.net, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: fix some typos
References: <5233DCD1.4010006@huawei.com>
In-Reply-To: <5233DCD1.4010006@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/13 20:49, Xishi Qiu wrote:

> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 0cfb00f..ca278d5 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -92,7 +92,7 @@ stack contents as the probed function.  When it is done, the handler
>  calls jprobe_return(), which traps again to restore the original stack
>  contents and processor state and switch to the probed function.
>  
> -By convention, the callee owns its arguments, so gcc may produce code

Are you sure about that?
It looks correct to me (before the patch).

> +By convention, the caller owns its arguments, so gcc may produce code
>  that unexpectedly modifies that portion of the stack.  This is why
>  Kprobes saves a copy of the stack and restores it after the jprobe
>  handler has run.  Up to MAX_STACK_SIZE bytes are copied -- e.g.,
> 


-- 
~Randy
