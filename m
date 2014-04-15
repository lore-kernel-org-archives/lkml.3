Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaDOAii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:38:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32211 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaDOAif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:38:35 -0400
X-AuditID: cbfee68f-b7f156d00000276c-52-534c7f89edd3
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Marc Zyngier'" <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
References: <000001cf57b4$d3450780$79cf1680$@samsung.com>
 <534C0A89.4090907@arm.com>
In-reply-to: <534C0A89.4090907@arm.com>
Subject: Re: [PATCH 2/8] arm/arm64: KVM: Fix line length exceeding 80 characters
Date: Tue, 15 Apr 2014 09:38:33 +0900
Message-id: <001601cf5843$07c38160$174a8420$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGLmoMFdN20WDBNcOw5kS98Jw2hKQDLK8SQm5L17AA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+ZsW5nvU+wwckHxhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZvFhxkpGB26PNfPW
	MHr8/jWJ0ePOtT1sHuc3rWH22Lyk3qNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy/rz4xV7w
	mbOiae5J9gbGz+xdjJwcEgImEm+3roeyxSQu3FvPBmILCSxjlLj8Qhum5vH5s6xdjFxA8UWM
	Et/mfGOGcP4wSix6MJURpIpNQFPi0d0esEkiQPbHnqdsIEXMAl+ZJG782gk1Nkzi6bPtTCA2
	p4C6xN75rcwgtrBAgETPw71gNouAqsS5OxNZQWxeAUuJe6ves0PYghI/Jt9jAbGZBbQk1u88
	zgRhy0tsXvOWGeJUBYkdZ18zQhxhJXFi3iaoehGJfS/eMYIcJCEwlUNixtodUMsEJL5NPgRU
	xAGUkJXYdABqjqTEwRU3WCYwSsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWl
	eel6yfm5mxghsd+/g/HuAetDjMlA6ycyS4km5wNTR15JvKGxmZGFqYmpsZG5pRlpwkrivPcf
	JgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYFzPHH/65/S9d/dtvXzFpsjNKTtEJz5578G3
	XUKMa8oZdlz7zSx5LuSMD0OnyJVvTrMvPVpzwc+yuftA++ttcVdnZH1f2/NngoXnq577T7ct
	aAmu/fIo8tskyyaG2r6v99PctCMOZ51qSlnBk/3SjKvmhd/PuiDXw3KBzVs35WSdEfF5JHMz
	cLMSS3FGoqEWc1FxIgB0qLfXEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAd3Oep9ggw339Sz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzeLDjJWMDtwea+at
	YfT4/WsSo8eda3vYPM5vWsPssXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzPjz4hd7wWfOiqa5J9kbGD+zdzFyckgImEg8Pn+WFcIWk7hwbz1b
	FyMXh5DAIkaJb3O+MUM4fxglFj2YyghSxSagKfHobg9YtwiQ/bHnKVgHs8BXJokbv3aygSSE
	BMIknj7bzgRicwqoS+yd38oMYgsLBEj0PNwLZrMIqEqcuzMRbDWvgKXEvVXv2SFsQYkfk++x
	gNjMAloS63ceZ4Kw5SU2r3nLDHGqgsSOs68ZIY6wkjgxbxNUvYjEvhfvGCcwCs1CMmoWklGz
	kIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg1PJMagfjygaLQ4wCHIxKPLwT
	3nkHC7EmlhVX5h5ilOBgVhLhfZ3sEyzEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cC0l1cS
	b2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjGlTfT4bnptkI/3i
	ypsIQ2NH/ZtWh1WeW1iEvhQvbwnSmiyz8bj8PZmFP1fWzVgskWK7MK6xRk/7hUbW6wk7F5VM
	TWr91j17k3WX127RZ5HnfzQvub2tYlugtVxhbKXALSkH3xOn/yX/jcipErOK/HT2/qtnshte
	SUd+fVwl+qQ40s9dctGDh0osxRmJhlrMRcWJAA63fPlxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 1:19 AM, Marc Zyngier wrote:
> On 14/04/14 08:40, Jungseok Lee wrote:
> > This patch deals with checkpatch complaint as fixing line length
> > exceeding 80 characters.
> >
> > WARNING: line over 80 characters
> >
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm/kvm/mmu.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c index
> > 80bb1e6..e0d4f24 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -563,8 +563,8 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
> >  	kvm->arch.pgd = NULL;
> >  }
> >
> > -static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> > -			     phys_addr_t addr)
> > +static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache
> > +			     *cache, phys_addr_t addr)
> 
> Please don't. This makes the code unreadable (and no, I don't care about checkpatch ;-).

Okay. I will drop this patch from the next version.

It would be good to change stage2_set_pmd_huge function for readability
if you don't care about checkpatch.

Best Regards
Jungseok Lee

