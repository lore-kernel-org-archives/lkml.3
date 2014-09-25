Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaIYRSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:18:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:48864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaIYRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:18:37 -0400
Message-ID: <54244E68.90109@infradead.org>
Date: Thu, 25 Sep 2014 10:18:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
CC: Pranith Kumar <bobby.prani@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] Docs: this_cpu_ops: remove redundant add forms
References: <1411566583-22220-1-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1411566583-22220-1-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 06:49, Mark Rutland wrote:
> Hi,
> 
> I spotted the below while trying to figure out how to use this_cpu ops,
> and it left me confused for a short while.
> 
> I guess that this is a refactoring fallout rather than there being a
> special this_cpu_add variant?
> 
> Mark.
> 
> ---->8----
> Commit ac490f4dca94 (Documentation: this_cpu_ops.txt: Update description
> of this_cpu_ops) added lists of {__,}this_cpu operations, but these have
> duplicate, parameter-less entries for {__,}this_cpu_add which don't
> correspond to any implementation. No other operations have such
> duplicate entries.
> 
> Given both are also listed with their full complement of arguments, the
> empty forms are redundant and can be removed. This patch performs said
> removal.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Pranith Kumar <bobby.prani@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> ---
>  Documentation/this_cpu_ops.txt | 2 --
>  1 file changed, 2 deletions(-)


Applied, thanks.

> diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.txt
> index 0ec9957..2cbf719 100644
> --- a/Documentation/this_cpu_ops.txt
> +++ b/Documentation/this_cpu_ops.txt
> @@ -41,7 +41,6 @@ The following this_cpu() operations with implied preemption protection
>  are defined. These operations can be used without worrying about
>  preemption and interrupts.
>  
> -	this_cpu_add()
>  	this_cpu_read(pcp)
>  	this_cpu_write(pcp, val)
>  	this_cpu_add(pcp, val)
> @@ -225,7 +224,6 @@ still occur while an operation is in progress and if the interrupt too
>  modifies the variable, then RMW actions can not be guaranteed to be
>  safe.
>  
> -	__this_cpu_add()
>  	__this_cpu_read(pcp)
>  	__this_cpu_write(pcp, val)
>  	__this_cpu_add(pcp, val)
> 


-- 
~Randy
