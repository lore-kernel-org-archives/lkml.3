Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855AbaKOBlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:41:06 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60701 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965255AbaKOBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:41:04 -0500
MIME-Version: 1.0
In-Reply-To: <1415971986-16143-1-git-send-email-mgorman@suse.de>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de>
Date: Fri, 14 Nov 2014 17:41:02 -0800
X-Google-Sender-Auth: ySynO3lX4_wkMA3pfYTi6yKIOfw
Message-ID: <CA+55aFx-_EU6pgSY61YsA8qYVtNnz8PeJzU=h-NQy8pMJU-jxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 5:32 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> This series is very heavily based on patches from Linus and Aneesh to
> replace the existing PTE/PMD NUMA helper functions with normal change
> protections. I did alter and add parts of it but I consider them relatively
> minor contributions. Note that the signed-offs here need addressing. I
> couldn't use "From" or Signed-off-by from the original authors as the
> patches had to be broken up and they were never signed off. I expect the
> two people involved will just stick their signed-off-by on it.

Feel free to just take authorship of my parts, and make my
"Needs-sign-off's" be just "Acked-by:"

Or alternatively keep them as "Signed-off-by:", even when it looks a
bit odd if it doesn't have a "From:" me, when the actual patch won't
then actually go through me - I'm assuming this will come in through
the -mm tree.

As to the ppc parts, obviously it would be good to have Aneesh re-test
the series..

                    Linus
