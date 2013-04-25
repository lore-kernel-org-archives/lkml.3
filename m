Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab3DYAQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:16:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14469 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab3DYAQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:16:09 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-8a-517875c7c1ee
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Russell King'" <linux@arm.linux.org.uk>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
In-reply-to: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
Subject: [PATCH 3.8-stable] ARM: 7699/1: sched_clock: Add more notrace to
 prevent
Date: Thu, 25 Apr 2013 09:16:07 +0900
Message-id: <001501ce414a$14da9de0$3e8fd9a0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoAC1cPGAA1lnVSA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zY93jpRWBBjeblSyWNHNbXN41h83i
	9mVeix9nulksFmx8xOjA6tHS3MPmcbmvl8mjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mo5e
	f85WsIKvYtfBTewNjH+5uxg5OSQETCRuLZjKCGGLSVy4t56ti5GLQ0hgGaPEvVWfmWCKtl7s
	hEosYpR4cHkSI4Tzl1Hizbq9LCBVbAK6EsfWb2EFsUUEvCVOTfnFDGIzC+RI7D38FywuJGAn
	sebfPKBJHBycAvYSUz6XgYSFBYIlzn+eATaGRUBVYsvBRWwgNi9Q+bbTu1khbEGJH5PvsUCM
	1JJYv/M4E4QtL7F5zVtmkJESAuoSj/7qQlzgJ/Fr2xd2iBIRiX0v3oGdLCFwiV1iUn8TE8Qu
	AYlvkw+xQPTKSmw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UVG
	esWJucWleel6yfm5mxghsdm3g/HmAetDjMlA6ycyS4km5wNjO68k3tDYzMjC1MTU2Mjc0ow0
	YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjGYvmyPqKhdpXFjHXFnk2F5t2KrU
	+L1i2ruI915LvDweG6W0mFW95P3oacUkny9p96ftpYWJ9PzT7Tpl3k+/Sb9gfbRBLHqyz6fS
	TttpXUv2HXbWs0vQj20wC0yXPDAnxfrD2p3PDz1fk3b/0/pD03wjzl7mnZPCIaThtc7HxqXA
	oi14/8/DSizFGYmGWsxFxYkAECbwAeMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAd3jpRWBBt/fy1osaea2uLxrDpvF
	7cu8Fj/OdLNYLNj4iNGB1aOluYfN43JfL5NH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAK1VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWYcvf6crWAFX8Wug5vYGxj/cncxcnJICJhIbL3YyQZhi0lc
	uLceyObiEBJYxCjx4PIkRgjnL6PEm3V7WUCq2AR0JY6t38IKYosIeEucmvKLGcRmFsiR2Hv4
	L1hcSMBOYs2/eUCTODg4BewlpnwuAwkLCwRLnP88A2wMi4CqxJaDi8AW8wKVbzu9mxXCFpT4
	MfkeC8RILYn1O48zQdjyEpvXvGUGGSkhoC7x6K8uxAV+Er+2fWGHKBGR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHPnPpHcwrmqwOMQowMGo
	xMMr8Ko8UIg1say4MvcQowQHs5II7zKHikAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcm
	pbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYMx/cl2lNYVh
	C8sGmeW/TM8cKPc+xfRz+7ygkw/Pz/d5vff5IR/Pt4venN3hXchzT1bFf9Fhoz/+K1TFTpgy
	aai947nBs99A4GDzlNcXmabf/6QpvPiExWdVm4q48IczfZblGQS+y7suL/B9iXya0PmNZm/3
	FESLKm2JT7aIP7NpSvvBjw3L01yUWIozEg21mIuKEwFE+pecQAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Stephen Boyd <sboyd@codeaurora.org>"

commit cea15092f098b7018e89f64a5a14bb71955965d5 upstream

cyc_to_sched_clock() is called by sched_clock() and cyc_to_ns()
is called by cyc_to_sched_clock(). I suspect that some compilers
inline both of these functions into sched_clock() and so we've
been getting away without having a notrace marking. It seems that
my compiler isn't inlining cyc_to_sched_clock() though, so I'm
hitting a recursion bug when I enable the function graph tracer,
causing my system to crash. Marking these functions notrace fixes
it. Technically cyc_to_ns() doesn't need the notrace because it's
already marked inline, but let's just add it so that if we ever
remove inline from that function it doesn't blow up.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/kernel/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index bd6f56b..59d2adb 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -45,12 +45,12 @@ static u32 notrace jiffy_sched_clock_read(void)
 
 static u32 __read_mostly (*read_sched_clock)(void) =
jiffy_sched_clock_read;
 
-static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
+static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
-- 
1.7.9.5ml

