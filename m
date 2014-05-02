Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaEBFpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:45:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaEBFo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:44:59 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-e5-536330d88f4c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Jungseok Lee'" <jays.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, ilho215.lee@samsung.com
References: <000001cf64e5$c2d71e40$48855ac0$@samsung.com>
In-reply-to: <000001cf64e5$c2d71e40$48855ac0$@samsung.com>
Subject: RE: [PATCH v5 0/6] Support 4 levels of translation tables for ARM64
Date: Fri, 02 May 2014 14:44:56 +0900
Message-id: <06d401cf65c9$a60e2350$f22a69f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIgGGfT2CZ7yX0N73XxhyRYDOdXAJqLYfKQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zoe4Ng+Rgg+UbDS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGhx/+p3RouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	2sVLWQu2yVQc+XmWpYHxr0gXIyeHhICJxPT181ggbDGJC/fWs3UxcnEICSxjlJjUMRHI4QAr
	2tVdBBGfzijx4vZuVgjnL6PE8cO3mUG62QQ0JA6/f8YOYosIPGWUuPhFCaSIWeAcUFHDRSaQ
	SUIClhKzVqWCmJwCVhLLv3uBlAsL+Ei8evuWDcRmEVCVePpwC5jNC1Td0z2ZHcIWlPgx+R7Y
	ocwCWhLrdx5ngrDlJTavecsM8YCCxI6zrxlBxosIGElc6PeHKBGR2PfiHSPINRICCzkkrl9o
	gtolIPFt8iEWiB9lJTYdgBojKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6
	kbFecWJucWleul5yfu4mRkj89+9gvHvA+hBjMtD6icxSosn5wPSRVxJvaGxmZGFqYmpsZG5p
	Rpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY9WwuunQrbVgQ1v/p4eoNgcw8
	LhseFYVnCOp+t1Qvty+wdp7/sSsyL3T/xapIzamOsy6vSuU8+26B18W9YWEB5ya0K9S1aG+o
	Ot+w43PJ9PdnX5vJN9XZ3/5aLynzL+rkPLc5PGadJ5aL7ZL4WLjxTn6MnKDxg+gtmUHPahl6
	DVZu9hduC5+lxFKckWioxVxUnAgA8q05TxUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQd0bBsnBBn2vtC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGhx/+p3RouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjLWLl7IWbJOpOPLzLEsD41+RLkYODgkBE4ld3UVdjJxA
	ppjEhXvr2boYuTiEBKYzSry4vZsVwvnLKHH88G1mkCo2AQ2Jw++fsYPYIgJPGSUuflECKWIW
	OAdU1HCRCWSqkIClxKxVqSAmp4CVxPLvXiDlwgI+Eq/evmUDsVkEVCWePtwCZvMCVfd0T2aH
	sAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPEoQoSO86+ZgQZLyJgJHGh3x+iRERi34t3jBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwcnkmvYNxVYPF
	IUYBDkYlHl6N3KRgIdbEsuLK3EOMEhzMSiK8DRlAId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYS
	Tc4HJr68knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamCseeG0
	s0zeQasx4M4LQ/H3L8XnZVjYCa4IDXdb6mp1UMwggtGiY2XmFfXA8HS5d0tuhAjOXjBh7z1u
	v1npTKfVkq/1nY03TDq7S5m1Yc1jyz0sJ+O1dGee9Py9ddOGf1dzwpMXOzqcmP35RL8rm8WC
	mDcneNrPhc28dDqj8f8E/xSzqhtnLbOVWIozEg21mIuKEwHIo2D0cgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jungseok Lee wrote:
> 
> Hi All,
> 
> This v5 patchset supports 4 levels of tranlsation tables for ARM64.
> 
> Firstly, the patchset introduces virtual address space size and
> translation level options as taking account into the comment from
> Catalin Marinas:
> http://www.spinics.net/linux/lists/arm-kernel/msg319552.html
> 
> Then, it implements 4 levels of translation tables for native, HYP and
> stage2 sides.
> 
> All ARMv8 and ARMv7 related changes are validated with FastModels+kvmtool
> and
> A15+QEMU, respectively.
> 
> Changes since v1:
> - fixed unmatched data types as per Steve's comment
> - removed unnecessary #ifdef in arch/arm64/mm/* as per Steve's comment
> - revised create_pgd_entry to deal with PUD entry as per Steve's comment
> - introduced a macro for initial memblock limit as per Steve's comment
> - dropped "Fix line length exceeding 80 characters" patch as per Marc's
> comment
> - removed unnecessary #ifdef in arch/arm/kvm/mmu.c as per Marc's comment
> - added a macro for a number of objects of as per Marc's comment
> 
> Changes since v2:
> - revised some macros in a generic way as per Marc's comment
> - added a 2 level option for kvm mmu cache allocation as per Marc's
> comment
> 
> Changes since v3:
> - added #ifdef to decide swapper and idmap size as per Steve's comment
> - introduced Steve's create_pgd_entry
> 
> Changes since v4:
> - hided translation level options from menuconfig as per Catalin's comment
> - dropped some printk changes as per Mitchel's comment
> - squashed VA_BITS related patches into a single patch
> 
> Jungseok Lee (6):
>   arm64: Use pr_* instead of printk
>   arm64: Introduce VA_BITS and translation level options
>   arm64: Add a description on 48-bit address space with 4KB pages
>   arm64: Add 4 levels of page tables definition with 4KB pages
>   arm64: mm: Implement 4 levels of translation tables
>   arm64: KVM: Implement 4 levels of translation tables for HYP and
>     stage2
> 
>  Documentation/arm64/memory.txt                |   59 ++++++++++++++---
>  arch/arm/include/asm/kvm_mmu.h                |   10 +++
>  arch/arm/kvm/mmu.c                            |   88
+++++++++++++++++++++----
>  arch/arm64/Kconfig                            |   53 ++++++++++++++-
>  arch/arm64/include/asm/kvm_arm.h              |   34 ++++++++--
>  arch/arm64/include/asm/kvm_mmu.h              |   12 ++++
>  arch/arm64/include/asm/memblock.h             |    6 ++
>  arch/arm64/include/asm/memory.h               |    6 +-
>  arch/arm64/include/asm/page.h                 |    6 +-
>  arch/arm64/include/asm/pgalloc.h              |   24 ++++++-
>  arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 ++++++++++++++
>  arch/arm64/include/asm/pgtable-4level-types.h |   71 ++++++++++++++++++++
>  arch/arm64/include/asm/pgtable-hwdef.h        |    8 ++-
>  arch/arm64/include/asm/pgtable.h              |   53 +++++++++++++--
>  arch/arm64/include/asm/tlb.h                  |   11 +++-
>  arch/arm64/kernel/head.S                      |   46 ++++++++++---
>  arch/arm64/kernel/traps.c                     |   13 ++--
>  arch/arm64/mm/fault.c                         |    1 +
>  arch/arm64/mm/mmu.c                           |   16 +++--
>  19 files changed, 507 insertions(+), 60 deletions(-)
>  create mode 100644 arch/arm64/include/asm/pgtable-4level-hwdef.h
>  create mode 100644 arch/arm64/include/asm/pgtable-4level-types.h
> 
> --
> 1.7.10.4

Looks good to me and Samsung SoCs stuff :-)

All of this series:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

