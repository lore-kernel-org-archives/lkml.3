Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3JJVwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3JJVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:52:37 -0400
Date: Thu, 10 Oct 2013 14:52:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: calibrate: don't print out bogomips value on boot
Message-Id: <20131010145235.1c6574299bc636cf92190d32@linux-foundation.org>
In-Reply-To: <1381330640-32735-1-git-send-email-will.deacon@arm.com>
References: <1381330640-32735-1-git-send-email-will.deacon@arm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Oct 2013 15:57:20 +0100 Will Deacon <will.deacon@arm.com> wrote:

> @@ -295,9 +295,7 @@ void calibrate_delay(void)
>  	}
>  	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
>  	if (!printed)
> -		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
> -			lpj/(500000/HZ),
> -			(lpj/(5000/HZ)) % 100, lpj);
> +		pr_cont("lpj=%lu\n", lpj);
>  
>  	loops_per_jiffy = lpj;
>  	printed = true;

Kidding?  BogoMIPS is an industry-standard metric which was established
before many of us were born.  It even has its own wikipedia page!

You have no heart.
