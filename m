Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3KRXJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:09:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50634 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3KRXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:09:36 -0500
Date: Mon, 18 Nov 2013 18:09:35 -0500 (EST)
Message-Id: <20131118.180935.73842675326744218.davem@davemloft.net>
To: kirill.shutemov@linux.intel.com
Cc: sfr@canb.auug.org.au, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131118084941.A9C76E0090@blue.fi.intel.com>
References: <20131118141933.7314374b0157183e0613599d@canb.auug.org.au>
	<20131118084941.A9C76E0090@blue.fi.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Nov 2013 15:09:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 18 Nov 2013 10:49:41 +0200 (EET)

> Stephen Rothwell wrote:
>> Hi all,
>> 
>> After merging the final tree, today's linux-next build (sparc64 defconfig)
>> failed like this:
>> 
>> arch/sparc/mm/init_64.c: In function 'pte_alloc_one':
>> arch/sparc/mm/init_64.c:2568:9: error: unused variable 'pte' [-Werror=unused-variable]
>> 
>> Caused by the merge between commit 37b3a8ff3e08 ("sparc64: Move from 4MB
>> to 8MB huge pages") and commit 1ae9ae5f7df7 ("sparc: handle
>> pgtable_page_ctor() fail") (I had the following merge fix in linux-next,
>> but it didn't seem to propagate upstream - may have forgotten to point it
>> out :-().
>> 
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Mon, 18 Nov 2013 14:16:40 +1100
>> Subject: [PATCH] sparc64: merge fix
>> 
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Applied, thanks everyone.
