Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaBJXN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:13:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaBJXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:13:56 -0500
Date: Mon, 10 Feb 2014 15:13:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        mgorman@suse.de, aarcange@redhat.com, andi@firstfloor.org,
        riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-Id: <20140210151354.68fe414f81335d4ce0e4c550@linux-foundation.org>
In-Reply-To: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 12:27:44 -0500 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> HugeTLB command-line option hugepages= allows the user to specify how many
> huge pages should be allocated at boot. On NUMA systems, this argument
> automatically distributes huge pages allocation among nodes, which can
> be undesirable.

Grumble.  "can be undesirable" is the entire reason for the entire
patchset.  We need far, far more detail than can be conveyed in three
words, please!

> The hugepagesnid= option introduced by this commit allows the user
> to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> from node 0 only. More details on patch 3/4 and patch 4/4.
> 

