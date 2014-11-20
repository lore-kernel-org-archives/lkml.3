Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaKTVvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:51:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32129 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaKTVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:51:18 -0500
Message-ID: <546E6221.5000409@oracle.com>
Date: Thu, 20 Nov 2014 16:50:25 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/10] Replace _PAGE_NUMA with PAGE_NONE protections v2
References: <1416478790-27522-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1416478790-27522-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 05:19 AM, Mel Gorman wrote:
> V1 failed while running under kvm-tools very quickly and a second report
> indicated that it happens on bare metal as well. This version survived
> an overnight run of trinity running under kvm-tools here but verification
> from Sasha would be appreciated.

Hi Mel,

I tried giving it a spin, but it won't apply at all on the latest -mm
tree:

$ git am -3 numa/*
Applying: mm: numa: Do not dereference pmd outside of the lock during NUMA hinting fault
Applying: mm: Add p[te|md] protnone helpers for use by NUMA balancing
Applying: mm: Convert p[te|md]_numa users to p[te|md]_protnone_numa
fatal: sha1 information is lacking or useless (mm/huge_memory.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.

Did I miss a prerequisite?


Thanks,
Sasha
