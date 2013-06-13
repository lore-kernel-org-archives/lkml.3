Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab3FMWrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:47:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40680 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3FMWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:47:18 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-21-51ba4bf49849
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-samsung-soc@vger.kernel.org,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org, thomas.abraham@linaro.org
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
 <9948950.GZ51yJYkxQ@flatron>
In-reply-to: <9948950.GZ51yJYkxQ@flatron>
Subject: RE: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Fri, 14 Jun 2013 07:47:15 +0900
Message-id: <15dd01ce6887$f3d6d720$db848560$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5oWVGOtEJ9WoDISNasSbfYyF3+KAAK+jmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t8zfd0v3rsCDe7NFLWYs34Nm8Wsa0EW
	c863sFicXXaQzWLJz11MFlP+LGeyuLxrDpvFjPP7mCz2HD3MbnHq+mc2i617r7JbHJuxhNFi
	1a4/jA68Ho03brB5HLk9g9ljdsNFFo8pvzeyemxZeZPJY+esu+wed67tYfM4MeM3i8eVE02s
	Hu/3XWXz+LxJLoA7issmJTUnsyy1SN8ugSvjX/8/5oKjrBXz511hbWDcwdLFyMEhIWAisftu
	bBcjJ5ApJnHh3nq2LkYuDiGBZYwSk272skIkTCRurtrPCpGYzijxdPYCRgjnL6PEvfMXmEGq
	2AQ0JA6/f8YOMlVEIESiv1kZpIZZ4DCzxKZpfUwgNUICKRKPdy4Aq+cU0JT4NWEdM0i9sICt
	xNu9fiBhFgFVifkXD7CD2LxA4d/nb7JA2IISPybfA7OZBbQk1u88zgRhy0tsXvOWGeIZdYlH
	f3VBwiICRhKn/8yHKheR2PfiHdjJEgInOCRm/NzGBrFLQOLb5EPQgJCV2HSAGeJfSYmDK26w
	TGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUISRu8OxtsH
	rA8xJgOtn8gsJZqcD0w4eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgvJHAxJPp4amVobXm0vvqmfOU/EyYluz03evaa/UlrHCarYtTqefMZ4+/
	zTvDYBkXPHdOXV+xSVVT086HbdIhAdwTDEo2lux7MKv0WkXhJMXunqlPXm97qJVf4T05f8sD
	L1abmQtF7r7oeLs7QdRo/dq34akc/87Mt4k+J9u942f8/nV/AgReK7EUZyQaajEXFScCAILl
	kOUuAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jQd0v3rsCDTo+8lvMWb+GzWLWtSCL
	OedbWCzOLjvIZrHk5y4miyl/ljNZXN41h81ixvl9TBZ7jh5mtzh1/TObxda9V9ktjs1Ywmix
	atcfRgdej8YbN9g8jtyewewxu+Eii8eU3xtZPbasvMnksXPWXXaPO9f2sHmcmPGbxePKiSZW
	j/f7rrJ5fN4kF8Ad1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQP0gpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x41//P+aC
	o6wV8+ddYW1g3MHSxcjJISFgInFz1X5WCFtM4sK99WxdjFwcQgLTGSWezl7ACOH8ZZS4d/4C
	M0gVm4CGxOH3z9i7GDk4RARCJPqblUFqmAUOM0tsmtbHBFIjJJAi8XjnArB6TgFNiV8T1jGD
	1AsL2Eq83esHEmYRUJWYf/EAO4jNCxT+ff4mC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b8HG
	SAioSzz6qwsSFhEwkjj9Zz5UuYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzghPRMegfjqgaLQ4wCHIxKPLwJF3YGCrEmlhVX5h5ilOBgVhLh
	Df8LFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YLLMK4k3NDYxM7I0MrMwMjE3J01YSZz3
	YKt1oJBAemJJanZqakFqEcwWJg5OqQZG5e1H7t09VLpuvuz1iZP19f/PPHxG1P1jnYvlE98H
	lxfvXXlquZKN77K3D83eBb+crvxQ5S3TAbmzFhY7L2jwfL1lVJ9pePV6+IOXJtM3srNVVojL
	tj7hecCdp3LgjX9ZW79xkcykmjkfVl5fl9UZ7hfpEN/F6VL5kSXw+fRb3i9rFl1r0pzSp8RS
	nJFoqMVcVJwIACXWYBKMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
> > It's convenient if get_maintainer suggests sending samsung/exynos
> > pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry for
> > that.
> 
> Well, if we are already at it, we could list the actual maintainers of the
> driver.
> 
> The original maintainer was Thomas Abraham <thomas.abraham@linaro.org>

Should be original author?! I think, original maintainer was/is Linus
Walleij.

Let's see, probably original author should have some knowledge for it but
the meaning of the maintainer is different. Of course, would be helpful if
original author could review and maintain...

- Kukjin

