Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3HGUbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:31:09 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:51701 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab3HGUbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:31:07 -0400
Date: Thu, 8 Aug 2013 00:31:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        xemul@parallels.com, mpm@selenic.com, xiaoguangrong@linux.vnet.ibm.com,
        mtosatti@redhat.com, kosaki.motohiro@gmail.com, sfr@canb.auug.org.au,
        peterz@infradead.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 2/2] [PATCH] mm: Save soft-dirty bits on file pages
Message-ID: <20130807203103.GP7999@moon>
References: <20130730204154.407090410@gmail.com>
 <20130730204654.966378702@gmail.com>
 <20130807132812.60ad4bfe85127794094d385e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807132812.60ad4bfe85127794094d385e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 01:28:12PM -0700, Andrew Morton wrote:
> 
> Good god.
> 
> I wonder if these can be turned into out-of-line functions in some form
> which humans can understand.
> 
> or
> 
> #define pte_to_pgoff(pte)
> 	frob(pte, PTE_FILE_SHIFT1, PTE_FILE_BITS1) +
> 	frob(PTE_FILE_SHIFT2, PTE_FILE_BITS2) +
> 	frob(PTE_FILE_SHIFT3, PTE_FILE_BITS3) +
> 	frob(PTE_FILE_SHIFT4, PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)

I copied this code from existing one, not mine invention ;)
I'll clean it up on top.
