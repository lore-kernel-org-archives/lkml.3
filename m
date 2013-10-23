Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3JWLRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:17:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65525 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3JWLRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:17:39 -0400
X-AuditID: cbfee691-b7f866d000001b8c-0e-5267b0511a9f
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Ulf Hansson'" <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
 <1380207292-16968-7-git-send-email-ulf.hansson@linaro.org>
In-reply-to: <1380207292-16968-7-git-send-email-ulf.hansson@linaro.org>
Subject: RE: [PATCH 06/27] mmc: dw_mmc: Move away from using deprecated APIs
Date: Wed, 23 Oct 2013 20:17:37 +0900
Message-id: <001401cecfe1$7aa04c80$6fe0e580$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66yH/C9PU65BR4QiShqxuJTxgVUgVERffw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ93ADelBBts/yFpsf72RzeLGrzZW
	i8u75rBZHPnfz2hxfG24A6vHoStrGT3uXNvD5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	N97/ZClYw1xx6e419gbGW0xdjJwcEgImEuda37ND2GISF+6tZ+ti5OIQEljGKPHz/H1WmKLW
	BxOYIRLTGSVW33/FBOH8YZT48nYx2Cg2AS2Jv2/egFWJCLQwSpyePhusnVlAR+LstSY2EFtI
	oJlR4v/jki5GDg5OAXeJYxc1QMLCAj4SGyeuYwSxWQRUJSbe/Q5m8wrYSnRtnQxlC0r8mHyP
	BWKkgcT7WX1Q4+UlNq95ywwyUkJAXeLRX12QsIiAkcSfs41MECUiEvtevGMEOU1C4Bq7xKJ7
	K6B2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihO
	Si8y1StOzC0uzUvXS87P3cQIic+JOxjvH7A+xJgMtH4is5Rocj4wvvNK4g2NzYwsTE1MjY3M
	Lc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFK+vz+grnzS7/K+W9otEhn
	TLl1aQ33gRLJZS4+q7mC//SwSysf4nErdd/cFXjcU5Sl6Xt22p/Jh7RD2ZhzLic8T+Qxu/gi
	pyFxiv3Gc6YqbqLubErLrkvfmLB+V7iM36wD8bKS3/w/mn4wbN28pbJK7UIjW2CodnsgQ67S
	NLWS4GdBM+xXKbEUZyQaajEXFScCADSuAbLlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd3ADelBBq8mSllsf72RzeLGrzZW
	i8u75rBZHPnfz2hxfG24A6vHoStrGT3uXNvD5tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGTfe/2QpWMNccenuNfYGxltMXYycHBICJhKtDyYwQ9hi
	EhfurWfrYuTiEBKYziix+v4rJgjnD6PEl7eLwTrYBLQk/r55wwySEBFoYZQ4PX02K0iCWUBH
	4uy1JjYQW0igmVHi/+OSLkYODk4Bd4ljFzVAwsICPhIbJ65jBLFZBFQlJt79DmbzCthKdG2d
	DGULSvyYfI8FYqSBxPtZfVDj5SU2r3nLDDJSQkBd4tFfXZCwiICRxJ+zjUwQJSIS+168Y5zA
	KDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/+Z1A7GlQ0W
	hxgFOBiVeHgt2tOChFgTy4orcw8xSnAwK4nwrp+dHiTEm5JYWZValB9fVJqTWnyIMRno0YnM
	UqLJ+cDElFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjJ3r
	3icvnBn5cgfDCm+usuIwdee90dIS/tp6y8ycXE9tcH7g/X1L0SM502kH+IMqXjdkTxZRfiXQ
	opNfVm+yKvxnrNmax67Vv0s17M1bJD+2OLP3OC4MXupwO0isief7LGPLgBL3uSzJtb4J/ws1
	TzKu/2e99NiP5SZqoRyPDrTscTqy6GmHEktxRqKhFnNRcSIA40f2ukIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, September 26, 2013, Ulf Hansson wrote:
> Suspend and resume of cards are being handled from the protocol layer
> and consequently the mmc_suspend|resume_host APIs are deprecated.
> 
> This means we can simplify the suspend|resume callbacks by removing the
> use of the deprecated APIs.
> 
> Cc: Seungwon Jeon <tgih.jun@samsung.com>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon


