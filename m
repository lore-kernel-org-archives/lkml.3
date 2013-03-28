Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3C1PvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:51:15 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55617 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3C1PvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:51:13 -0400
Date: Thu, 28 Mar 2013 08:51:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH 1/2] hugetlbfs: stop setting VM_DONTDUMP in initializing
 vma(VM_HUGETLB)
Message-ID: <20130328155109.GA13075@kroah.com>
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:42:37AM -0400, Naoya Horiguchi wrote:
> Currently we fail to include any data on hugepages into coredump,
> because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> mm->reserved_vm counter". This looks to me a serious regression,
> so let's fix it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  fs/hugetlbfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
