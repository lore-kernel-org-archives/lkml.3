Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3JDANu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:13:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38154 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JDANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:13:48 -0400
X-AuditID: cbfee68e-b7f756d000004512-a2-524e083a9641
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>
Subject: [PATCH V2] MAINTAINERS: remove Richard Purdie as backlight maintainer
Date: Fri, 04 Oct 2013 09:13:46 +0900
Message-id: <003a01cec096$97c72040$c75560c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Alo8XvQFKTjvuRnSkhe+Mb6iWHg==
Content-language: ko
x-cr-hashedpuzzle: BoGM Xn+B eXiQ lXv9 mvdL npam rykf 2LtV 5vTG 9cA0 ABGknA==
 ACiM1g== ADO3Xg== AHfJ6Q== AHfXIw==
 AIIeEQ==;11;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGcAcwBoAGEAcgBrAC4AagBlAG8AbgBnAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABhAHUAcgBlAG4AdAAuAHAAaQBuAGMAaABhAHIAdAArAHIAZQBuAGUAcwBhAHMAQABpAGQAZQBhAHMAbwBuAGIAbwBhAHIAZAAuAGMAbwBtADsAbABpAG4AdQB4AC0AZgBiAGQAZQB2AEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQBpAGMAaABhAGUAbAAuAGgAZQBuAG4AZQByAGkAYwBoAEAAYQBuAGEAbABvAGcALgBjAG8AbQA7AG0AaQBsAG8ALgBrAGkAbQBAAHQAaQAuAGMAbwBtADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0ADsAdABoAGkAZQByAHIAeQAuAHIAZQBkAGkAbgBnAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwB0AG8AbQBpAC4AdgBhAGwAawBlAGkAbgBlAG4AQAB0AGkALgBjAG8AbQA=;Sosha1_v1;7;{76679E36-FA20-430E-A9F7-2D72836ECEAF};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 04 Oct 2013 00:13:31 GMT;WwBQAEEAVABDAEgAIA
	BWADIAXQAgAE0AQQBJAE4AVABBAEkATgBFAFIAUwA6ACAAcgBlAG0AbwB2AGUAIABSAGkAYwBoAGEAcgBkACAAUAB1AHIAZABpAGUAIABhAHMAIABiAGEAYwBrAGwAaQBnAGgAdAAgAG0AYQBpAG4AdABhAGkAbgBlAHIA
x-cr-puzzleid: {76679E36-FA20-430E-A9F7-2D72836ECEAF}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zsa4Vh1+QwZlJGhZz1q9hs5i8u4vV
	4vLCS6wWE5vusFic6PsA5O6aw2Yx4fBmdovlv9axWOze9ZTV4ueueSwW6+ffYnPg9nh11dFj
	56y77B6zO2ayepyY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkAjigum5TUnMyy1CJ9uwSujJuf
	tQu+sFcsPCnZwLiZrYuRk0NCwESi5f0nZghbTOLCvfVAcS4OIYFljBL3Tj6HK5pw+xcrRGIR
	o8Sn3ceZIZxfjBJtn2YzgVQJC/hJNM2ZBDaKTUBN4suXw+xdjBwcIgL6Em0tGiD1zAJLmSUW
	zdrPAlO/evlVVhCbRUBV4vP5a2C9vAK2EssvPWWCsAUlfky+B1bPLKAlsXlbEyuELS+xec1b
	ZpD5EgLqEo/+6oKERQT0JM7fOwRVIiKx78U7RpC9EgKrOCXmr1/PAvGNqcTcqx/YIBJLOSRe
	v1/GBnGEgMS3yYdYIIbKSmw6AA0WSYmDK26wTGCUnIXkpFlITpqF5KRZSHYvYGRZxSiaWpBc
	UJyUXmSkV5yYW1yal66XnJ+7iRGSGPp2MN48YH2IMRlo/URmKdHkfGBiySuJNzQ2M7IwNTE1
	NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo+LO44alk6e0cM9Wtz2y
	SyBl/4lPB8X/2Uhsc+IL2bxwu/b5/75Two56JlRvev9R9o9m88b8rX/SHtTZ/Vz9VJ6L/92+
	j8mqv0qWZE55uNhSqPG5o1e5VgefqvvRSyFvHnwTqN7ok3bCorY4yGP/uYT3FwR11j2ZfnD1
	tLjaNy//7xMWrNokcVaJpTgj0VCLuag4EQA7/BoeIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAV0rDr8gg22TlSzmrF/DZjF5dxer
	xeWFl1gtJjbdYbE40fcByN01h81iwuHN7BbLf61jsdi96ymrxc9d81gs1s+/xebA7fHqqqPH
	zll32T1md8xk9Tgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QJcqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwnrGDNuftYu+MJesfCkZAPjZrYuRk4OCQETiQm3f7FC2GISF+6t
	B4pzcQgJLGKU+LT7ODOE84tRou3TbCaQKmEBP4mmOZOYQWw2ATWJL18Os3cxcnCICOhLtLVo
	gNQzCyxlllg0az8LTP3q5VfBNrAIqEp8Pn8NrJdXwFZi+aWnTBC2oMSPyffA6pkFtCQ2b2ti
	hbDlJTavecsMMl9CQF3i0V9dkLCIgJ7E+XuHoEpEJPa9eMcIsldCYBWnxPz161kgvjGVmHv1
	A9sERuFZSFbMQrJiFpIVs5DMWsDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOO08k9rB
	uLLB4hCjAAejEg+vQK1vkBBrYllxZe4hRgkOZiUR3tOfgEK8KYmVValF+fFFpTmpxYcYk4Eh
	MJFZSjQ5H5gS80riDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	Mbqs2sziUZm+0oVnV/zWT1r3Ztqf41GBExXPXgmpDS+RnSRzoMmDv8tuYfft76u2LLGZpv/2
	3NqI3L8P+uy4/Zcd+e7z19iixNRjuvFSb1ZPMQUXi98nvvUp9i3k8OgpezJlxkZ+B8X1b7U/
	+LfV37o17/I2g3m1HqxTbzXyr9SoTWGYq2a2UImlOCPRUIu5qDgRAASGKdh/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Richard Purdie as backlight subsystem maintainer, since he
is not responding for a few years.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 CREDITS     |    5 +++++
 MAINTAINERS |    1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 0640e16..dfe3cf8 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2895,6 +2895,11 @@ S: Framewood Road
 S: Wexham SL3 6PJ
 S: United Kingdom
 
+N: Richard Purdie
+E: rpurdie@rpsys.net
+D: Backlight subsystem maintainer
+S: USA
+
 N: Daniel Quinlan
 E: quinlan@pathname.com
 W: http://www.pathname.com/~quinlan/
diff --git a/MAINTAINERS b/MAINTAINERS
index 5678de3..3a967c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1651,7 +1651,6 @@ S:	Maintained
 F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
-M:	Richard Purdie <rpurdie@rpsys.net>
 M:	Jingoo Han <jg1.han@samsung.com>
 S:	Maintained
 F:	drivers/video/backlight/
-- 
1.7.10.4


