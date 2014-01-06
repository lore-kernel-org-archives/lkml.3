Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaAFLY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:24:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbaAFLY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:24:26 -0500
Date: Mon, 6 Jan 2014 12:24:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Bob Liu <bob.liu@oracle.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: could you clarify mm/mempolicy: fix !vma in new_vma_page()
Message-ID: <20140106112422.GA27602@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng Li,
I have just noticed 11c731e81bb0 (mm/mempolicy: fix !vma in
new_vma_page()) and I am not sure I understand it. Your changelog claims
"
    page_address_in_vma() may still return -EFAULT because of many other
    conditions in it.  As a result the while loop in new_vma_page() may end
    with vma=NULL.
"

And the patch handles hugetlb case only. I was wondering what are those
"other conditions" that failed in the BUG_ON mentioned in the changelog?
Could you be more specific please?

Thanks!
-- 
Michal Hocko
SUSE Labs
