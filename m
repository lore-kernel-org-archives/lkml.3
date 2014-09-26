Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaIZHX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:23:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44418 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaIZHXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:23:31 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-6a-5425146d47b7
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, cw00.choi@samsung.com, vikas.sajjan@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 0/2] ARM: EXYNOS3250: Add support EXYNOS3250 suspend/resume.
Date: Fri, 26 Sep 2014 16:23:20 +0900
Message-id: <1411716202-31644-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWyRsSkQDdPRDXEYN8aFovrX56zWnSefcJs
	0bvgKpvFpsfXWC0u75rDZjHj/D4mi5vPtjM5sHtsXlLv0bdlFaPH501yAcxRXDYpqTmZZalF
	+nYJXBkNpx6wFJxkqVj89y1TA+Nd5i5GTg4JAROJdUeOsELYYhIX7q1n62Lk4hASWMoosXvz
	UzaYosYV+5khEtMZJWY2T2SBcNqYJP4fucMCUsUmoCPxf99NdhBbRCBbYv7ebjCbWaBE4sKi
	rWA1wgI+ErOfvQGLswioStz60AEW5xXwkFi37yhTFyMH0DYFiTmTbEDmSwi8Z5PoPLCBGaJe
	QOLb5EMsEDWyEpsOQH0gKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIE
	Bujpf88m7GC8d8D6EKMAB6MSD2/DGpUQIdbEsuLK3EOMpkAbJjJLiSbnA+MgryTe0NjMyMLU
	xNTYyNzSTEmc97XUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNn1y0+IHlbre3U2i6na
	1sXZukeucnflyRv/63yP/XFWvdEjx7oggDtfXLGmR/mEmArn8WMypfdCz7c8sTfnzz34NWyW
	vfymlE5ppr8sf5ZuXfore0Jr+7r6HXMUu7L+7Mv/O+3r68PcVyY9Omaxf8ap/3XvTlbONJuq
	u21avnv2gVOmEgbqkUosxRmJhlrMRcWJAFDnUy5LAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xoG6uiGqIwd39VhbXvzxnteg8+4TZ
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFjefbWdyYPfYvKTeo2/LKkaPz5vkApijGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzGk49YCk4yVKx+O9bpgbGu8xdjJwcEgImEo0r
	9kPZYhIX7q1n62Lk4hASmM4oMbN5IguE08Yk8f/IHRaQKjYBHYn/+26yg9giAtkS8/d2g9nM
	AiUSFxZtBasRFvCRmP3sDVicRUBV4taHDrA4r4CHxLp9R5m6GDmAtilIzJlkM4GRewEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4PB/JrWDcWWDxSFGAQ5GJR7eG+tUQoRYE8uKK3MP
	MUpwMCuJ8G7kUA0R4k1JrKxKLcqPLyrNSS0+xGgKtHwis5Rocj4wNvNK4g2NTcyMLI3MDS2M
	jM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTC62erEKRnGNjAt0g2YePPH0c7pPEf1w2Z9
	/7M6ZU6HwAW7Q75MIcuuf/1qtEWgy75029nMnHO2u04VRM3R6llWvvl70mfrRtcHjn2s6vUJ
	Lp+z53tfmb9q/sbJHHXrb9lFCG/p4eTdre259dzBp15LZyw4/lf794tr623Dd838eTyhILNU
	ZMJHJZbijERDLeai4kQAsq5MsJUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches adds and modifies exynos suspend driver to support exynos3250's
suspend/resume. To work suspend/resume, it also needs a work at pmu driver.
It'll be supported after refactoring job on pmu driver is done.

Jonghwa Lee (2):
  ARM: EXYNOS: suspend: Make restoring registers into selectable
    option.
  ARM: EXYNOS3250: Add initial support EXYNOS3250 suspend/resume.

 arch/arm/mach-exynos/regs-pmu.h |    4 +++
 arch/arm/mach-exynos/suspend.c  |   70 +++++++++++++++++++++++++++++----------
 2 files changed, 56 insertions(+), 18 deletions(-)

-- 
1.7.9.5

