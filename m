Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3FCJlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30744 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3FCJlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:41:10 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-89-51ac64b4d8fa
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Marc Zyngier'" <marc.zyngier@arm.com>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>
Cc: "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "'Mark Rutland'" <Mark.Rutland@arm.com>,
        "'Barry Song'" <baohua.song@csr.com>,
        "'Daniel Walker'" <dwalker@fifo99.com>,
        "'Bryan Huntsman'" <bryanh@codeaurora.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
 <20130531174526.GD599@codeaurora.org> <51A8E71D.1000407@linaro.org>
 <20130531221633.GG599@codeaurora.org> <51AC59AB.4080802@arm.com>
In-reply-to: <51AC59AB.4080802@arm.com>
Subject: RE: [PATCHv6 00/11] Remove ARM local timer API
Date: Mon, 03 Jun 2013 18:41:08 +0900
Message-id: <049801ce603e$79aad240$6d0076c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5gN+pCmyiYq84RStS4h0Kgp/2HwwABi1ow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t8zfd0tKWsCDfY9MLU49mULm8XfScfY
	LV7OvMpq8e/YFCaLeZ9lLaYua2O1OPNb12LT42usFhP3n2W3uLxrDlDpnX9sFkuvX2Sy+HGm
	m8Vi86apzBbHZixhtNh/xctBwGPNvDWMHr9/TWL0+PZ1EovH5b5eJo9dO+ewepyevJ/FY9Oq
	TjaPO9f2sHm8O3eO3WPzknqPz5vkArijuGxSUnMyy1KL9O0SuDLaFr5mKWjmqLgz/yprA+NC
	ti5GTg4JAROJppk/mSFsMYkL99YDxbk4hASWMUr8X7KFFabo1uHnLBCJ6YwSX1++YYZw/jJK
	tOydzAhSxSagIXH4/TN2EFtEIEDi941bYGOZBSaySFzaoQHRcIZR4tKnVWANnALqElcap4PZ
	wgLmEh9XrAOzWQRUJSY0HAOzeQVsJc5/XsoEYQtK/Jh8jwViqJbE+p3HmSBseYnNa94CLeMA
	OlVd4tFfXYgbjCS292xhgygRkdj34h0jyA0SAhc4JL4tX8YCsUtA4tvkQywQvbISmw5Ag0JS
	4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkHQy
	YQfjvQPWhxiTgdZPZJYSTc4HpqO8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTC6NUYX/t91yaZBQelymJmzgzBbR/jVOZ89s85NWnD3TatKSqDU
	EwulNpk/IaKHN1W9Dc7cnJB6z4A7SHt3mNiceU5zVDz8LBz/e/W3KokwJTLHvM6T6N0vNOuY
	D4ODWaXk8Tib2L+Rp66oz7+us9Nqx4otN5a/eV8x0dWMc+FTR1OLqSzrnJRYijMSDbWYi4oT
	AUsgLKE9AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42I5/e+xoO6WlDWBBrt+6Fsc+7KFzeLvpGPs
	Fi9nXmW1+HdsCpPFvM+yFlOXtbFanPmta7Hp8TVWi4n7z7JbXN41B6j0zj82i6XXLzJZ/DjT
	zWKxedNUZotjM5YwWuy/4uUg4LFm3hpGj9+/JjF6fPs6icXjcl8vk8eunXNYPU5P3s/isWlV
	J5vHnWt72DzenTvH7rF5Sb3H501yAdxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUDvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEy
	QAMJ6xgz2ha+Zilo5qi4M/8qawPjQrYuRk4OCQETiVuHn7NA2GISF+6tB4pzcQgJTGeU+Pry
	DTOE85dRomXvZEaQKjYBDYnD75+xg9giAgESv2/cYgaxmQUmskhc2qEB0XCGUeLSp1VgDZwC
	6hJXGqeD2cIC5hIfV6wDs1kEVCUmNBwDs3kFbCXOf17KBGELSvyYfI8FYqiWxPqdx5kgbHmJ
	zWveAi3jADpVXeLRX12IG4wktvdsYYMoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iRGcrJ5J72Bc1WBxiFGAg1GJhzfAY02gEGtiWXFl7iFG
	CQ5mJRHeK4FAId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJtK8knhDYxMzI0sjMwsjE3Nz
	0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDkNbORZxTSuBd95uOJNtvdQtsW7zsQXMO4
	Xd9nef5N98P7/+3O8chTVEv8sIW1iud8mobUvS5lyYzfPY5h/2yVMv+IpIXfdDnUGfJ+UtPH
	X7eEL8iXGf6sy7m44f5Ph9+/lXfwT2Tcui3fzcxs+7wpppansgJOKZyIfNp1QC5zvUvyN+db
	fy2VWIozEg21mIuKEwE3qMQ1mgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Zyngier wrote:
> 
> On 31/05/13 23:16, Stephen Boyd wrote:
> > On 05/31, John Stultz wrote:
> >> On 05/31/2013 10:45 AM, Stephen Boyd wrote:
> >>> Comments have been light for this round so I think we're about
> >>> ready to merge. John/Thomas, can you pick up these patches or
> >>> shall I route them through arm-soc or something else?
> >>
> >>
> >> So there looks to be a fair amount of additions in the ARM tree, do
> >> those already have acks from Arnd/Olof/other folks? (I think I was
> >> only cc'ed on the first two patches).
> >
> > I'm still missing acks from Kukjin and Barry.
> 
Stephen, I replied on exynos stuff in this series.

> I don't think that should hold off the patch series. It's been tested on
> most other platforms over the course of several months. If the platform
> maintainers aren't responsive enough, fixing the issues becomes their
> problem.
> 
Marc, I understand what you're saying. Let me look at the regarding exynos
stuff carefully.

Thanks.

- Kukjin

