Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3GHFNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:13:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45660 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3GHFNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:13:21 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-2c-51da4a686d60
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
 <51D6A370.7060604@st.com> <002801ce7b98$e1520f60$a3f62e20$@samsung.com>
In-reply-to: <002801ce7b98$e1520f60$a3f62e20$@samsung.com>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Mon, 08 Jul 2013 14:13:12 +0900
Message-id: <002901ce7b99$d7e42930$87ac7b90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQII16kcxw44AVHNORO1PoktmeAs2wG+yqifAbxODj+YyasLUA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zA90Mr1uBBg0PpC3+TjrGbrGkKcPi
	5SFNi8sLL7Fa9C64ymZxedccNouz846zWcw4v4/JYuPUX4wW7ZeULRqPPmC1aH3ygNGBx+P3
	r0mMHgs2lXp8Xzif3aNvyypGj6c/9jJ7fN4kF8AWxWWTkpqTWZZapG+XwJXRfW4BW8FKtor9
	qyYzNTC+ZOli5OSQEDCRmHp3HzOELSZx4d56NhBbSGAZo0T7VgmYmu8Lu5m6GLmA4osYJX7v
	/8oG4fxilNg88yY7SBWbgJrEly+HwWwRgQCJrVePMYIUMQucZZJY+OQbI0RHM6NEz7s7rCBV
	nAJWErva5zGC2MICcRITXj0H62YRUJVY3HMHzOYVsJTo+HiNGcIWlPgx+R7Y3cwCWhLrdx5n
	grDlJTaveQv1g4LEjrOvGSGucJJ4t+IHM0SNiMS+F+/AjpAQmMohMXP9OhaIZQIS3yYfArI5
	gBKyEpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQv
	XS85P3cTIyTuJ+xgvHfA+hBjMtD6icxSosn5wLSRVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1
	oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG62/hMrXzroeqrE0oZ/+04aQTg0/e81yebJ6v
	T5hmhr3JLjzQ7+ss9PPKo4dsEdLmb8xyeeYZFd/vv9Tc9uwOs6tsViCbU3rlpBUmDu7WO5uL
	Pk9n1l+2y/d117PVQfzTVxzclrrPJYVfUZrp/M4l0xWY/S/KHeP3YmTVz5hxk93F1lV5wn0l
	luKMREMt5qLiRAALcOleEQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAd0Mr1uBBrM/iln8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3i8q45bBZn5x1ns5hxfh+Txcapvxgt2i8pWzQefcBq0frkAaMDj8fv
	X5MYPRZsKvX4vnA+u0ffllWMHk9/7GX2+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYR1jRve5BWwFK9kq9q+azNTA+JKli5GTQ0LAROL7wm4mCFtM4sK99WxdjFwc
	QgKLGCV+7/8K5fxilNg88yY7SBWbgJrEly+HwWwRgQCJrVePMYIUMQucZZJY+OQbI0RHM6NE
	z7s7rCBVnAJWErva5zGC2MICcRITXj0H62YRUJVY3HMHzOYVsJTo+HiNGcIWlPgx+R7YfcwC
	WhLrdx5ngrDlJTavecsMcauCxI6zrxkhrnCSeLfiBzNEjYjEvhfvGCcwCs1CMmoWklGzkIya
	haRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgtPJMagfjygaLQ4wCHIxKPLwSp28G
	CrEmlhVX5h5ilOBgVhLhFWe9FSjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cCUl1cSb2hs
	YmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjOuU1n5csNPgs5BoNH/b
	oeVdgXahOcf73vNPv8Ft+9v+tEwSu87zRrZjPGeKftxa/PzShqUui9NfhE3u/sH36Dz3Xh7P
	uLD7LgtN3qYrWzUKu2zxuLjuiXDMzMJ7iTPWKBoc2fJiZaTmljuJqkdOLo79VWF8Zabb81+6
	d+79kFTfbbqDsVkkRkWJpTgj0VCLuag4EQAcRzsfbwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 08, 2013 2:06 PM, Jingoo Han wrote:
> On Friday, July 05, 2013 7:44 PM, Pratyush Anand wrote:
> > On 7/5/2013 1:59 PM, Jingoo Han wrote:
> > > Exynos PCIe IP consists of Synopsys specific part and Exynos
> > > specific part. Only core block is a Synopsys designware part;
> > > other parts are Exynos specific.
> > > Also, the Synopsys designware part can be shared with other
> > > platforms; thus, it can be split two parts such as Synopsys
> > > designware part and Exynos specific part.
> > >
> >
> > A quick and nice job :)
> > Just few minor comments.
> 
> Thank you.
> Without your comment, it could be done. :)

Oops, it is a typo.
Without your comment, it could 'NOT' be done. :)

Thank you for your comment.
It is very helpful.

Best regards,
Jingoo Han


