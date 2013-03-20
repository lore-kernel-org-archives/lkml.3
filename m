Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3CTVfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3CTVfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:35:45 -0400
Date: Wed, 20 Mar 2013 17:35:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <1363815326-urchkyxr-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <5148F830.3070601@gmail.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <5148F830.3070601@gmail.com>
Subject: Re: [RFC][PATCH 0/9] extend hugepage migration
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <5148F830.3070601@gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 07:43:44AM +0800, Simon Jeons wrote:
...
> >Easy patch access:
> >   git@github.com:Naoya-Horiguchi/linux.git
> >   branch:extend_hugepage_migration
> >
> >Test code:
> >   git@github.com:Naoya-Horiguchi/test_hugepage_migration_extension.git
> 
> git clone
> git@github.com:Naoya-Horiguchi/test_hugepage_migration_extension.git
> Cloning into test_hugepage_migration_extension...
> Permission denied (publickey).
> fatal: The remote end hung up unexpectedly

Sorry, wrong url.
git://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git
or
https://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git
should work.

Thanks,
Naoya
