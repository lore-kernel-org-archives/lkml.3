Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3KUAwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:52:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3KUAwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:52:09 -0500
Message-ID: <528D5935.6070907@infradead.org>
Date: Wed, 20 Nov 2013 16:52:05 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: mmotm 2013-11-20-16-13 uploaded (arch/um/kernel/sysrq.c)
References: <20131121001408.17DC85A41C6@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20131121001408.17DC85A41C6@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 16:14, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-11-20-16-13 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 

on i386:
(with um i386 defconfig)

arch/um/kernel/sysrq.c:22:13: error: expected identifier or '(' before 'do'
um/kernel/sysrq.c:22:13: error: expected identifier or '(' before 'while'


so sysrq.c is picking up <linux/stacktrace.h> somehow and not liking it.


-- 
~Randy
