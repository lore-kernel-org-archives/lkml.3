Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3DWC7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:59:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48585 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3DWC7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:59:15 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-55-5175f9025f77
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] ARM: S3C24XX: Correct NR_IRQS definition for s3c2440
Date: Tue, 23 Apr 2013 11:59:13 +0900
Message-id: <007101ce3fce$894d9920$9be8cb60$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA6SbUA==
Content-language: ko
x-cr-hashedpuzzle: J49w Lwtz NNGT TRp7 ai9C bAXc dtil e85x ovZU zTUt 0r+d 2cDN
 9TCR AAXS6g== AA1rPQ==
 AA/Chg==;6;agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAawBnAGUAbgBlAC4AawBpAG0AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcwAuAG4AYQB3AHIAbwBjAGsAaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AHMAdABhAGIAbABlAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB0AG8AbQBhAHMAegAuAGYAaQBnAGEAQABnAG0AYQBpAGwALgBjAG8AbQA=;Sosha1_v1;7;{18B9E403-2F85-4D69-87CF-68894BBB963E};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Tue,
 23 Apr 2013 02:59:02
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOAAtAHMAdABhAGIAbABlAF0AIABBAFIATQA6ACAAUwAzAEMAMgA0AFgAWAA6ACAAQwBvAHIAcgBlAGMAdAAgAE4AUgBfAEkAUgBRAFMAIABkAGUAZgBpAG4AaQB0AGkAbwBuACAAZgBvAHIAIABzADMAYwAyADQANAAwAA==
x-cr-puzzleid: {18B9E403-2F85-4D69-87CF-68894BBB963E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfV2mn6WBBmsOClksaea26F1wlc3i
	8q45bBaH37SzWizY+IjRYtWuP4wObB47Z91l9+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
	hsWLmQvm8VWsWXecpYGxj6eLkZNDQsBE4t6Zq6wQtpjEhXvr2boYuTiEBJYxSlya9YMNpmjD
	uZVQiemMEo+nrgJLCAn8ZZRY3+QMYrMJ6EocW78FbJKIgLfEqSm/mEEamAVmMEoc6noClOAA
	auCWWN0cBFLDKcAjse5PJzOILSwQIDGv+TETiM0ioCpxcOEURhCbV8BO4sOSf2wQtqDEj8n3
	WEBsZgEtifU7jzNB2PISm9e8ZQYZLyGgLvHory7ECU4S61f3Q5WISOx78Y4R5BwJgRNsEscX
	PYb62FRi1afv7BCJr+wSO96tZYE4QkDi2+RDLBBDZSU2HWCGqJeUOLjiBssERqlZSE6aheSk
	WUhOmoVk9wJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIfHcu4Px9gHrQ4zJQOsnMkuJ
	JucD00FeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghh3XjeKWy2Uf3vJt1dv45eeS5yw+9ah7I/3s18Zx/w69m7DTyOZByGH5+fJ2RzeWzM568Gi
	/MVHPOY07mW88VInYCfTD/+Te39sCJnZILae9aL683MaP3eYHjzVz2jR7HYwvqph74mPP+bL
	Scd9X7fTbvK/W9X/jvb8mfFsx+OpG1Q+t/KeNF1+XFWJpTgj0VCLuag4EQDGQNg6/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV2mn6WBBt/n8Fksaea26F1wlc3i
	8q45bBaH37SzWizY+IjRYtWuP4wObB47Z91l9+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjIbFi5kL5vFVrFl3nKWBsY+ni5GTQ0LARGLDuZVsELaY
	xIV764FsLg4hgemMEo+nrgJLCAn8ZZRY3+QMYrMJ6EocW7+FFcQWEfCWODXlFzNIA7PADEaJ
	Q11PgBIcQA3cEqubg0BqOAV4JNb96WQGsYUFAiTmNT9mArFZBFQlDi6cwghi8wrYSXxY8o8N
	whaU+DH5HguIzSygJbF+53EmCFteYvOat8wg4yUE1CUe/dWFOMFJYv3qfqgSEYl9L94xgpwj
	IXCCTeL4osesEI+ZSqz69J19AqPILCQrZiFZMQvJillIZi1gZFnFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJEZwsnkntYFzZYHGIUYCDUYmHV8C9NFCINbGsuDL3EKMEB7OSCK9oPlCINyWx
	siq1KD++qDQntfgQYzIwBCYyS4km5wMTWV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNIT
	S1KzU1MLUotgtjBxcEo1MGZxak7l+sd9Kmhmo+KM9w+kM7paHkacjtn6qVVuZ1rTlUd6dxpX
	G3670WflIBmt/vujpMfuNxqCKydkKFb5/J+Wzf7Bemt9I9/trSsNT9x6u3TlxhWvyt/zs7kd
	8MgTXsc038YrtmN/9v+n0zRvOhx++2Pz2x2HOaf3e7S/znR8zxdgHaU24ZMSS3FGoqEWc1Fx
	IgAh6tMBWgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Sylwester Nawrocki <s.nawrocki@samsung.com>"

commit b530f742ac27460d41d35b638ad6aad92044a982 upstream.

Due to NR_IRQS being incorrectly defined not all IRQ domains can
be registered for S3C2440. It causes following errors on a s3c2440
SoC based board:

NR_IRQS:89
S3C2440: IRQ Support
irq: clearing pending status 00000002
------------[ cut here ]------------
WARNING: at kernel/irq/irqdomain.c:234 0xc0056ed0()
...
irq: could not create irq-domain
...
s3c2410-wdt s3c2410-wdt: failed to install irq (-22)
s3c2410-wdt: probe of s3c2410-wdt failed with error -22
...
samsung-uart s3c2440-uart.0: cannot get irq 74

Fix this by increasing NR_IRQS to at least (IRQ_S3C2443_AC97 + 1)
if CPU_S3C2440 is selected, so the subintc IRQ domain gets properly
registered.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-s3c24xx/include/mach/irqs.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/include/mach/irqs.h
b/arch/arm/mach-s3c24xx/include/mach/irqs.h
index b7a9f4d..1e73f5f 100644
--- a/arch/arm/mach-s3c24xx/include/mach/irqs.h
+++ b/arch/arm/mach-s3c24xx/include/mach/irqs.h
@@ -188,10 +188,8 @@
 
 #if defined(CONFIG_CPU_S3C2416)
 #define NR_IRQS (IRQ_S3C2416_I2S1 + 1)
-#elif defined(CONFIG_CPU_S3C2443)
-#define NR_IRQS (IRQ_S3C2443_AC97+1)
 #else
-#define NR_IRQS (IRQ_S3C2440_AC97+1)
+#define NR_IRQS (IRQ_S3C2443_AC97 + 1)
 #endif
 
 /* compatibility define. */
-- 
1.7.9.5

