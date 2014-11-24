Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaKXNWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:22:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14398 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaKXNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:22:25 -0500
X-AuditID: cbfee68d-f79296d000004278-28-5473310e2142
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 12/12] arm64: Kconfig: Enable PM_GENERIC_DOMAINS for
 exynos7
Date: Mon, 24 Nov 2014 18:34:16 +0530
Message-id: <1416834256-11225-12-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkVpfPsDjEYPs6G4uGqyEW84+cY7V4
	dmsvk0XvgqtsFk83P2ay2PT4GqvF5V1z2Cw+9x5htJhxfh+TxaKtX9gtzpy+xGpx+E07q8Xx
	teEOvB6bVnWyedy5tofN49DhDkaPzUvqPbZcbWfx6NuyitHj8ya5APYoLpuU1JzMstQifbsE
	roylt3+wFKxlqfj08CZjA+Mh5i5GDg4JAROJKc8Nuxg5gUwxiQv31rOB2EICSxklrt3hgilZ
	P9u2i5ELKDydUeL1hUmMEM4EJon3r86zgDSwCRhL/Ny5nx2kQUTAW2L5NUWQGmaB1UwSW9s/
	MIHUCAuESixs6mYHsVkEVCWarvezgNTzCnhITHibALFLQWLOJBuQCk6g6IuDLcwQq1oYJS49
	nssK4kgIXGKX2HGymRlijoDEt8mHWCCaZSU2HWCG+EVS4uCKGywTGIUXMDKsYhRNLUguKE5K
	LzLUK07MLS7NS9dLzs/dxAiMldP/nvXuYLx9wPoQowAHoxIP74eNRSFCrIllxZW5hxhNgTZM
	ZJYSTc4HRmReSbyhsZmRhamJqbGRuaWZkjivotTPYCGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2Ms0+53VqUknvwk/si/T0KJ6dYygcqZ/2a1F33tJCpYPeTFr9599JmBrhccn1gUzrf8eck
	b/uP1/Tvrnh/OmSSwO3Ib+u7LrDvzue16rVXilPRWltcdjzqhf+Uiu82i35P3XxHWsJDWf+X
	5cNvs7/0tOZMD7/U6LnPM+F4Xf4d+0WJFv3LJ9i/VWIpzkg01GIuKk4EAGsOcYSQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQV0+w+IQg+u3jSwaroZYzD9yjtXi
	2a29TBa9C66yWTzd/JjJYtPja6wWl3fNYbP43HuE0WLG+X1MFou2fmG3OHP6EqvF4TftrBbH
	14Y78HpsWtXJ5nHn2h42j0OHOxg9Ni+p99hytZ3Fo2/LKkaPz5vkAtijGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jBmLL39g6VgLUvFp4c3GRsYDzF3MXJwSAiYSKyfbdvF
	yAlkiklcuLeerYuRi0NIYDqjxOsLkxghnAlMEu9fnWcBqWITMJb4uXM/O0iziIC3xPJriiA1
	zAKrmSS2tn9gAqkRFgiVWNjUzQ5iswioSjRd72cBqecV8JCY8DYBYq+CxJxJNiAVnEDRFwdb
	mCFWtTBKXHo8l3UCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR+ExqB+PKBotD
	jAIcjEo8vB82FoUIsSaWFVfmHmKU4GBWEuEVEysOEeJNSaysSi3Kjy8qzUktPsRoCnTURGYp
	0eR8YKLIK4k3NDYxNzU2tTSxMDGzVBLnvXEzN0RIID2xJDU7NbUgtQimj4mDU6qBcd7f79Wl
	37NWC/N/DH1pZxCQX7OqZf6zCVxNnzR3lokv8Zz7ZMO61hexNts+zQ/I57giyal32/gkd7XI
	7y8rP3wJ5P/a33X9+7/zpzO9TdbHLlqTfG3eb8uvZhsmBn0pXRD7faPJMZ7nrGUWCz6xru8N
	51fMf6Khzyh3YLZVkPfDoriNuf36RUosxRmJhlrMRcWJADgmnCrcAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power domain driver for Exynos7 SOC's

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 30bd4d5..b102d0b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -154,6 +154,7 @@ config ARCH_EXYNOS7
 	bool "ARMv8 based Samsung Exynos7"
 	select ARCH_EXYNOS
 	select COMMON_CLK_SAMSUNG
+	select PM_GENERIC_DOMAINS
 	help
 	  This enables support for Samsung Exynos7 SoC family
 
-- 
1.7.9.5

