Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaFBILp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:11:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44215 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFBILm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:11:42 -0400
X-AuditID: cbfee68f-b7fef6d000003970-e6-538c31bbe0c3
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000501cf6dc6$44fac0f0$cef042d0$@samsung.com>
 <20140527135349.GJ31431@lvm> <20140527140241.GA13967@lvm>
In-reply-to: <20140527140241.GA13967@lvm>
Subject: Re: [PATCH v6 6/7] arm64: KVM: Set physical address size related
 factors in runtime
Date: Mon, 02 Jun 2014 17:11:39 +0900
Message-id: <07fe01cf7e3a$47d4e010$d77ea030$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG2fBziCOs+dwwtqW8kp0GuGivgVQFGrDjLAtsHS4ybbmmpsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zse5uw55ggwsNBhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJWx
	79d7loIt4hXTb29maWA8K9TFyMEhIWAisWVyXBcjJ5ApJnHh3nq2LkYuDiGBZYwSC3fdZ4Gp
	Of0lGiK+iFHiWfdRFgjnD6NE55OtzCDdbAKaEo/u9rCD2CJADZ/vzQObxCzwlkni945pYAkh
	gVKJ1Ze2soDYnEAN95/vYwWxhQXiJKYu7GUCsVkEVCW23J7EBmLzClhKfJ74nxXCFpT4Mfke
	WC+zgJbE+p3HmSBseYnNa94yQ7ygILHj7GtGkKtFBJwkrv2ugygRkdj34h0jyD0SAks5JJ4e
	aoXaJSDxbfIhqC9lJTYdgBojKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6
	kbFecWJucWleul5yfu4mRkgC6N/BePeA9SHGZKD1E5mlRJPzgQkkryTe0NjMyMLUxNTYyNzS
	jDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw7lpxh0df7tylwB+zF62cEyHP
	k2huMXtLX4Zig8M3/7uCNxl0jbkjYq56zjCqmfTqavFFh20Zn28WzqrWNRNQ9DAM61v05YGp
	3a5bU7fbmi0yluKfr6OiovXpXnTAFmbRz0U593XV9vv+5P+18aR2/3aGIC4TGf3zrLXPN0Qs
	kWxWfnv3fwSfEktxRqKhFnNRcSIARPAeVRYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd3dhj3BBkfWaVn8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjH2/3rMUbBGvmH57M0sD41mhLkYODgkBE4nTX6K7GDmB
	TDGJC/fWs3UxcnEICSxilHjWfZQFwvnDKNH5ZCszSBWbgKbEo7s97CC2CFDz53vzwDqYBd4y
	SfzeMQ0sISRQKrH60lYWEJsTqOH+832sILawQJzE1IW9TCA2i4CqxJbbk9hAbF4BS4nPE/+z
	QtiCEj8m3wPrZRbQkli/8zgThC0vsXnNW2aIUxUkdpx9zQjygYiAk8S133UQJSIS+168Y5zA
	KDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE8wz6R2Mqxos
	DjEKcDAq8fD+UO8JFmJNLCuuzD3EKMHBrCTCe/Rsd7AQb0piZVVqUX58UWlOavEhxmSgRycy
	S4km5wOTX15JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1ME7Z
	zB/FnnSFr1ls9QWNv3n157X7xW+1Lnso8fhxnmenncEfDQHT/QFSctWNxnbTg/7e49ge5J+7
	7srlHoa6VSXlb2fa5eWp3fg3ba3B5oiohUf/XdlT9U7jpHbVpfl6H+fd/jXTY8uX39O/fdvv
	MrHhTfPGg3J72eVa53FNY5icqPjC9kzFrZ1KLMUZiYZazEXFiQAMQM6CdAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 27, 2014 11:03 PM, Christoffer Dall wrote:
> On Tue, May 27, 2014 at 03:53:49PM +0200, Christoffer Dall wrote:
> > On Mon, May 12, 2014 at 06:40:54PM +0900, Jungseok Lee wrote:
> > > This patch sets TCR_EL2.PS, VTCR_EL2.T0SZ and vttbr_baddr_mask in runtime,
> > > not compile time.
> > >
> > > In ARMv8, EL2 physical address size (TCR_EL2.PS) and stage2 input address
> > > size (VTCR_EL2.T0SZE) cannot be determined in compile time since they
> > > depends on hardware capability.
> >
> > s/depends/depend/
> >
> > >
> > > According to Table D4-23 and Table D4-25 in ARM DDI 0487A.b document,
> > > vttbr_x is calculated using different hard-coded values with consideration
> >
> > super nit: I guess this is fixed values, and not hard-coded values
> >
> > > of T0SZ, granule size and the level of translation tables. Therefore,
> > > vttbr_baddr_mask should be determined dynamically.
> >
> > so I think there's a deeper issue here, which is that we're not
> > currently considering that for a given supported physical address size
> > (run-time) and given page granularity (compile-time), we may have some
> > flexibility in choosing the VTCR_EL2.SL0 field, and thereby the size of
> > the initial stage2 pgd, by concatinating the initial level page tables.
> >
> > Additionally, the combinations of the givens may also force us to choose
> > a specific SL0 value.
> >
> > Policy-wise, I would say we should concatenate as many initial level page
> > tables as possible when using 4K pages, iow. always set VTCR_EL2.SL0 to
> > the lowest possible value given the PARange and page size config we have
> > at hand.  That should always provide increased performance for VMs at
> > the cost of maximum 16 concatenated tables, which is a 64K contiguous
> > allocation and alignment, for 4K pages.
> >
> > For 64K pages, it becomes a 256K alignment and contiguous allocation
> > requirement.  One could argue that if this is not possible on your
> > system, then you have no business runninng VMs on there, but I want to
> > leave this open for comments...
> >
> Just had a brief chat with Marc, and he made me think of the fact that
> we cannot decide this freely, because the code in kvm_mmu.c assumes that
> the stage-2 page tables have the same number of levels etc. as the host
> kernel (we re-use functions like pud_offset, pud_addr_end, etc. etc.).
> 
> I'm not sure this can always be aligned, so we may have to write our own
> kvm_... versions of these to accomodate the best policy for KVM.

I agree with your opinion in performance and long-term perspective. We
should consider all combinations and re-write code if needed.

However, I'm not sure that this work should be included in this patch series.

If this functionality is needed, it would be good to prepare the work as
a separate patchset and drop off the last 2 KVM patches. Instead, 4 level
features should be marked as EXPERIMENTAL.

- Jungseok Lee

