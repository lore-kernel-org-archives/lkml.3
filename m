Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBKD6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:58:18 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:9934 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaBKD6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:58:16 -0500
Message-ID: <1392091093.2501.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, andi@firstfloor.org, riel@redhat.com
Date: Mon, 10 Feb 2014 19:58:13 -0800
In-Reply-To: <20140210151354.68fe414f81335d4ce0e4c550@linux-foundation.org>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
	 <20140210151354.68fe414f81335d4ce0e4c550@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 15:13 -0800, Andrew Morton wrote:
> On Mon, 10 Feb 2014 12:27:44 -0500 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > HugeTLB command-line option hugepages= allows the user to specify how many
> > huge pages should be allocated at boot. On NUMA systems, this argument
> > automatically distributes huge pages allocation among nodes, which can
> > be undesirable.
> 
> Grumble.  "can be undesirable" is the entire reason for the entire
> patchset.  We need far, far more detail than can be conveyed in three
> words, please!

One (not so real-world) scenario that comes right to mind which can
benefit for such a feature is the ability to study socket/node scaling
for hugepage aware applications. Yes, we do have numactl to bind
programs to resources, but I don't mind having a way of finer graining
hugetlb allocations, specially if it doesn't hurt anything.

Thanks,
Davidlohr

