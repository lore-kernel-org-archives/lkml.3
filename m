Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbbATWzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:55:12 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:35883 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbbATWzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:55:10 -0500
Date: Wed, 21 Jan 2015 00:54:43 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <pmoore@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: linux-next: Tree for Jan 20
Message-ID: <20150120225443.GA19629@node.dhcp.inet.fi>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120202642.GA6178@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120202642.GA6178@roeck-us.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 12:26:42PM -0800, Guenter Roeck wrote:
> ---
> sparc:
> 
> # bad: [5d0eebbbb6f76de160f7d7f9dc0b64a98ad9b8e9] Add linux-next specific files for 20150120
> # good: [ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc] Linux 3.19-rc5
> git bisect start 'HEAD' 'v3.19-rc5'
> # good: [f933e94e8f597c709068e58daa92570d5aa13b8c] Merge remote-tracking branch 'drm/drm-next'
> git bisect good f933e94e8f597c709068e58daa92570d5aa13b8c
> # good: [88cf70c4dd4a3851bf5531c0a51dec298d9690b5] Merge remote-tracking branch 'usb/usb-next'
> git bisect good 88cf70c4dd4a3851bf5531c0a51dec298d9690b5
> # good: [3ee33b3893f72e5a504ba873ee4a308896d97645] Merge remote-tracking branch 'cgroup/for-next'
> git bisect good 3ee33b3893f72e5a504ba873ee4a308896d97645
> # bad: [5925961a2889ec2b3734be9f3a6375822010f7a7] fs-befs-linuxvfsc-remove-unnecessary-casting-fix
> git bisect bad 5925961a2889ec2b3734be9f3a6375822010f7a7
> # bad: [fff9d1d082bb48a0d0e89aaaf746718fcef3a47f] mm: memcontrol: default hierarchy interface for memory fix
> git bisect bad fff9d1d082bb48a0d0e89aaaf746718fcef3a47f
> # good: [ab090dcbdd276e9ddcd0ecb666389aa85c30c76f] powerpc: drop _PAGE_FILE and pte_file()-related helpers
> git bisect good ab090dcbdd276e9ddcd0ecb666389aa85c30c76f
> # good: [91408e6db5842ed4bb66e2a3919b67a5f06ac34a] mm/hugetlb: fix suboptimal migration/hwpoisoned entry check
> git bisect good 91408e6db5842ed4bb66e2a3919b67a5f06ac34a
> # bad: [8e94896c7510e69bbd2acf418ad3a8afb9978c97] fs: consolidate {nr,free}_cached_objects args in shrink_control
> git bisect bad 8e94896c7510e69bbd2acf418ad3a8afb9978c97
> # bad: [5995b76d501a8f4d315f811698db98ac997d706f] x86: mm: restore original pte_special check
> git bisect bad 5995b76d501a8f4d315f811698db98ac997d706f
> # good: [b75c721aa3e2df5c52d4b6bce3dd687018c1f40c] mm: convert p[te|md]_numa users to p[te|md]_protnone_numa
> git bisect good b75c721aa3e2df5c52d4b6bce3dd687018c1f40c
> # good: [ce4188d335ac91a004087fb0ea86b85091ad570b] mm: convert p[te|md]_mknonnuma and remaining page table manipulations
> git bisect good ce4188d335ac91a004087fb0ea86b85091ad570b
> # bad: [625fa33ba695d73baa58afa44ab063f67e5f4b64] mm: numa: do not trap faults on the huge zero page
> git bisect bad 625fa33ba695d73baa58afa44ab063f67e5f4b64
> # good: [c2a7c97cc4bc3d46e98908d7dee07ab3e00a5257] mm: remove remaining references to NUMA hinting bits and helpers
> git bisect good c2a7c97cc4bc3d46e98908d7dee07ab3e00a5257
> # first bad commit: [625fa33ba695d73baa58afa44ab063f67e5f4b64] mm: numa: do not trap faults on the huge zero page

Could you provide more info about the fail in qemu?

-- 
 Kirill A. Shutemov
