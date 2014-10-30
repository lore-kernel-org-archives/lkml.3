Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbaJ3JBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:01:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:54830 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbaJ3JBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:01:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the akpm-current tree
In-Reply-To: <20141030161921.0e204257@canb.auug.org.au>
References: <20141030161921.0e204257@canb.auug.org.au>
User-Agent: Notmuch/0.18.2+145~g9619379 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Thu, 30 Oct 2014 14:30:39 +0530
Message-ID: <87lhny7wzs.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103009-0017-0000-0000-0000006D73BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (arm multi_v7_defconfig)
> produced this warning:
>
> In file included from include/linux/mm.h:52:0,
>                  from mm/gup.c:7:
> arch/arm/include/asm/pgtable.h:184:0: warning: "pgd_huge" redefined
>  #define pgd_huge(pgd)  (0)
>  ^
> In file included from mm/gup.c:6:0:
> include/linux/hugetlb.h:183:0: note: this is the location of the previous definition
>  #define pgd_huge(x) 0
>  ^
>
> Introduced by commit fee025d5dd4e ("mm: update generic gup
> implementation to handle hugepage directory").


Should be fixed by.
http://mid.gmane.org/1414570785-18966-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
IIUC the changes are going via powerpc tree. So not sure how it gets updated.

-aneesh

