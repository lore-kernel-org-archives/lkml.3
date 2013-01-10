Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3AJTd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:33:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12142 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3AJTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:33:58 -0500
X-AuditID: cbfee61b-b7f616d00000319b-40-50ef17a4c707
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Joerg Roedel'" <joro@8bytes.org>
Cc: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
 <032401cde783$485ae1a0$d910a4e0$@samsung.com>
 <20130110171844.GA2650@8bytes.org>
 <027601cdef61$2df576a0$89e063e0$@samsung.com>
 <20130110191207.GI25591@8bytes.org>
In-reply-to: <20130110191207.GI25591@8bytes.org>
Subject: RE: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Thu, 10 Jan 2013 11:33:41 -0800
Message-id: <02ae01cdef69$67d66200$37832600$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFIekVXHKw0ow7bnqULS98EzrZJiAHrktOYAWxAehQBVbax7gIWEG/nmRe/PGA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zY90l4u8DDKbvFbe4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4/nMHe8E3toolh7ezNDAuY+1i5OSQEDCR2Lf8CJQt
	JnHh3nq2LkYuDiGBZYwS319tZocpWr+2gRUisYhRYkvnb6iqv4wSD7pmMoNUsQloSBx+/wys
	Q0RARaLl3A+wOLPALmaJqeckIBpeMEp8nTORCSTBKWAg0XXjGthuYYFEidUXdoLFWQRUJQ48
	Wc0IYvMKWEoc+PqDCcIWlPgx+R4LxFAtifU7jzNB2PISm9e8ZYY4VUFix9nXjBBH+Eks+DKH
	HaJGXGLSg4fsEPMFJL5NPgQ0hwOoXlZi0wFmkNskBJaxS3y63M4IMUdS4uCKGywTGCVmIVk9
	C8nqWUhWz0KyYgEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MkEiT3sG4qsHiEKMAB6MS
	D6+W77sAIdbEsuLK3EOMEhzMSiK8LQuAQrwpiZVVqUX58UWlOanFhxh9gC6fyCwlmpwPTAJ5
	JfGGxsYmZiamJuaWpuamOISVxHkZTz0JEBJITyxJzU5NLUgtghnHxMEp1cBonZ86gf/wD/63
	345djdDt9lTQmf9oTuqaD9cDf2u9n3RmOstVZtkLe+77FE78G2PwZYkw6zrd8kU/3Kq3tfFK
	b5XYlWuXqxuxZYVQxsIcpeYjuaHuxgd/2Ewo3q0Sf+ntjiUuq4N2zi5rZ/667iSbPMOmi/d/
	nyh8ee1Gp9pbH0eVuSkdO49nKrEUZyQaajEXFScCAAdAOFrhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd0l4u8DDD79FrK4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+P5zB3vBN7aK
	JYe3szQwLmPtYuTkkBAwkVi/tgHKFpO4cG89WxcjF4eQwCJGiS2dv6Gcv4wSD7pmMoNUsQlo
	SBx+/4wdxBYRUJFoOfcDLM4ssItZYuo5CYiGF4wSX+dMZAJJcAoYSHTduAa2QlggUWL1hZ1g
	cRYBVYkDT1Yzgti8ApYSB77+YIKwBSV+TL7HAjFUS2L9zuNMELa8xOY1b5khTlWQ2HH2NSPE
	EX4SC77MYYeoEZeY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREcx8+kdzCuarA4xCjAwajEw6vl+y5AiDWxrLgy9xCjBAezkghvywKgEG9KYmVV
	alF+fFFpTmrxIUYfoE8nMkuJJucDU0xeSbyhsYmZkaWRmYWRibk5DmElcV7GU08ChATSE0tS
	s1NTC1KLYMYxcXBKNTDqtSfZ/vkuJd8787KdCR/XnU0zt609vqxirsu75bwnGoQnKm1cIpDo
	FHfyZE/wzPdx/+ZcFJt7a7PbppP8mo/Kyg7/+xW8cMPV5bumhZ1axcd4kv1qql99za/O3/dm
	y1V075rSsu1aYsReA9mUJhHG6SnaTd+mnXmw1i74VVzU/QUJKfs7uefFKLEUZyQaajEXFScC
	AP/RMNQQAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'Joerg Roedel' wrote:
> 
> On Thu, Jan 10, 2013 at 10:34:48AM -0800, Kukjin Kim wrote:
> > Hmm, I think, just one [7/12] patch does matter so if you could create
topic
> > branch and apply [7/12] patch firstly before other drivers/ changes
would
> be
> > better to me. It's OK on both trees if I just _merge_ the first [7/12]
> > commit in the topic branch you provided for exynos-iommu. But you know,
> you
> > don't have to rebase it once I merge it in Samsung tree.
> >
> > How about?
> 
> Sounds good. Should I take the patch directly from this post? I would
> add your Acked-by then and make it the base for the arm/exynos branch.

Sure, keep going on with

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> Once the branch is set-up, as usual it will not be rebased.

OK, good. Let me know the name of branch when you set-up it :-)

Thanks.

- Kukjin

