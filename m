Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3BMFdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 00:33:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3BMFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 00:33:40 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-2e-511b25a3fa4f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'KyongHo Cho'" <pullip.cho@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>
Cc: "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'devicetree-discuss'" <devicetree-discuss@lists.ozlabs.org>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Sylwester Nawrocki'" <sylvester.nawrocki@gmail.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>
References: <003801cde30b$d9667b90$8c3372b0$%cho@samsung.com>
 <50E1E62B.3090501@gmail.com>
 <CAHQjnOMav9A43m4=7=N9kzEHTHE_q_ygu8x6mzY6Cus=q0c06A@mail.gmail.com>
 <20130201135114.GF25591@8bytes.org>
 <CAHQjnOP1U=LRU-fe-HuWzp=17s=KG8zPvSO3_zeVrrviEkmyHw@mail.gmail.com>
In-reply-to: <CAHQjnOP1U=LRU-fe-HuWzp=17s=KG8zPvSO3_zeVrrviEkmyHw@mail.gmail.com>
Subject: RE: [PATCH v6 05/12] iommu/exynos: support for device tree
Date: Tue, 12 Feb 2013 21:33:01 -0800
Message-id: <1e0d01ce09ab$98eed690$cacc83b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQILZGQOFL5qVrul8iab0XF5eGwNiwGSgecdAoP3+p0BTjPF3AGsUc74l8QFq8A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zQ93FqtKBBltWslhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUc2aFcMIejYvalDywNjCvYuhg5OSQETCR+L//LDmGL
	SVy4tx4ozsUhJLCMUeL1kSdwReePL2SGSExnlDi96AorSEJI4C+jxPF5SiA2m4CGxOH3z8Am
	iQj4SHQ/ns0K0sAscJtFomPuTFaI7glMEitXt7GAVHEKBEucuNzABGILCzhLXHx4CqybRUBV
	4uTF50A2BwevgKXEylY7kDCvgKDEj8n3wFqZBbQk1u88zgRhy0tsXvOWGeJSBYkdZ18zQhzh
	J/H24B2oGnGJSQ8esoPcICGwjl3i3N5DzBC7BCS+TT7EArJLQkBWYtMBqDmSEgdX3GCZwCgx
	C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525ihESZ1A7GlQ0WhxgF
	OBiVeHgdQqQChVgTy4orcw8xSnAwK4nwTuCQDhTiTUmsrEotyo8vKs1JLT7EmAx07ERmKdHk
	fGACyCuJNzQ2NjEzMTUxtzQ1NyVNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjGKPebba
	X4iYdOD3tkUbrhSnJVws3Hl2AyeXz/WfvdVP5rtF+u7xXS+2eeHduNjqbPEZqjZ1Hhf4n//J
	vXfRzO0F6weZ+zWbOlZaLKyvUNSLzBaxL7mWepEv8eTUafe88t8UH/xVcSffykDR/e9pY6mA
	TTe0WSoru68HCN3yVVkgL2t+hk1VU4mlOCPRUIu5qDgRABz7TqD2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd1FqtKBBlNuWVlc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHNmhXDCHo2L2
	pQ8sDYwr2LoYOTkkBEwkzh9fyAxhi0lcuLceKM7FISQwnVHi9KIrrCAJIYG/jBLH5ymB2GwC
	GhKH3z9jB7FFBHwkuh/PZgVpYBa4zSLRMXcmK0T3BCaJlavbWECqOAWCJU5cbmACsYUFnCUu
	PjwF1s0ioCpx8uJzIJuDg1fAUmJlqx1ImFdAUOLH5HtgrcwCWhLrdx5ngrDlJTaveQt1qYLE
	jrOvGSGO8JN4e/AOVI24xKQHD9knMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4Bh+JrWDcWWDxSFGAQ5GJR5ehxCpQCHWxLLiytxDjBIczEoivBM4pAOF
	eFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YXvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRA
	SCA9sSQ1OzW1ILUIZgsTB6dUA6OYySoZi5kzElU1U5g4J2ueO6jk+Szy99FVAsbXGlXDzJmm
	W+xh2+rxbpX78pJyrR/X3hW5eUT+Pt18/aRxnMDnIz/rzxjMfPDPT6LazS54sfCmoEe37Xdr
	cDDtnDDZouC6kNK7/E8LhWdPrNW3svaSMZaK/Bc8Mbkg+oLedQX3KyZzLl1VXaLEUpyRaKjF
	XFScCAAEqshMJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KyongHo Cho wrote:
> 
> On Fri, Feb 1, 2013 at 10:51 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > Cho,
> >
> > On Wed, Jan 02, 2013 at 02:53:49PM +0900, KyongHo Cho wrote:
> >> On Tuesday, January 1, 2013, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com>
> >
> >> > Cc: devicetree-discuss@lists.ozlabs.org
> >
> > Since patch 7 of this set is already merged, do you mind to re-post the
> > rest of this patch-set with the latest comments addressed? I can have a
> > look at it again then and consider it for 3.9.
> >
> Thank you for your considerations.
> 
> I also think that I need to post the patch set again with some fixes that
are
> addressed in the comments.
> 
> Due to the heavy workload in my business I have hardly had a chance to
> handle this patch-set.
> As soon as the business lets me handle other pending issues, I will
> work on this patchset.
> I think I can start to it in the next 2 weeks.
> 
OK, I see.

Joerg, please hold this on until KyongHo's re-work, probably 3.10?

Thanks.

- Kukjin

