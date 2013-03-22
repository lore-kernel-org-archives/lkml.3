Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab3CVPDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:03:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28865 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab3CVPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:03:30 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-2a-514c72c17d5d
Date: Fri, 22 Mar 2013 15:03:29 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon in 3.8
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130322145617396@eunb.song
Msgkey: 20130322145617396@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130322145617396@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25790716.2181363964608452.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zpu7BIp9Ag0XneSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGul9f2Qu28VQc2fyFvYGxg6eLkZNDSEBFouX/d0YQW0LAROLC
	sqdMELaYxIV769m6GLmAapYxSpw4vYIJpqjz7BxGiOb5jBL7p4eD2CwCqhJXFrSwgthsAtoS
	b788ALOFBVIkdq/cCGaLCKhJHLrdCzaHWaBG4tWfKywQc+QlJp++zA5i8woISpyc+YQFYpeS
	xPt/s4HqOYDiyhL335RDhCUkZk2/wAph80rMaH8KVS4nMe3rGmYIW1ri/KwNjDC/LP7+GCrO
	L3Hs9g6wkSC9T+4Hw4zZvfkLG4QtIDH1zEGoVnWJO882sUPYfBJrFr5lgRmz69RyZpje+1vm
	Qn2lKDGl+yE7hK0l8eXHPjZ0X/EKOEg0L+lkmsCoPAtJahaS9llI2pHVLGBkWcUomlqQXFCc
	lF5kqlecmFtcmpeul5yfu4kRkhQm7mC8f8D6EGMyMEYmMkuJJucDk0peSbyhsZmRhamJqbGR
	uaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgPR+WVdlb3Xol6+jZO3NZB
	R+tZDD9P4tIwpawY8YSMb/d7WoQmzWY4ove3Vv1obJ5ThldI3ua9J657OZ29kLmz+4kFx+OT
	G28x7neOPtVwl8fkPvdvQ4cnMhM3NV7q557Jxi8f7x73OzynonFF8OuLJV2h4tc0PvDMqs6y
	umfQUWfBV+7wTImlOCPRUIu5qDgRAHiGkyUgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TN2DRT6BBgvesFtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jHW/vrIXbOOpOLL5C3sDYwdPFyMnh5CAikTL/++MILaEgIlE59k5ULaYxIV769kgauYzSuyf
	Hg5iswioSlxZ0MIKYrMJaEu8/fIAzBYWSJHYvXIjmC0ioCZx6HYvE4jNLFAj8erPFRaIOfIS
	k09fZgexeQUEJU7OfMICsUtJ4v2/2UD1HEBxZYn7b8ohwhISs6ZfYIWweSVmtD+FKpeTmPZ1
	DTOELS1xftYGuJMXf38MFeeXOHZ7B9hIkN4n94Nhxuze/IUNwhaQmHrmIFSrusSdZ5vYIWw+
	iTUL37LAjNl1ajkzTO/9LXOhvlKUmNL9kB3C1pL48mMfG7qveAUcJJqXdDJNYJSbhSQ1C0n7
	LCTtyGoWMLKsYhRNLUguKE5KrzDUK07MLS7NS9dLzs/dxAhOT88W7mD8ct76EKMAB6MSD6+G
	jnegEGtiWXFl7iFGCQ5mJRHepQU+gUK8KYmVValF+fFFpTmpxYcYk4HxN5FZSjQ5H5g680ri
	DY0NjA0NLc0NTA2NLEgTVhLnfdpqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB8ZzqVFdrlVm5nRdE
	PlyPPZ3NeOFZ9PQDjLv0z8X8+9NlURUrvah8vcqC5z4LH3zXcEyRroraHn935RaT8GobwbJn
	Og86DrYG/o22irfRLtnAfrJWzlIxNN+9MUWjLDjvj7BYWPHU+f/vtbLc35LSFrPqkUareFr/
	est48w9cPpNterSqvt5QYinOSDTUYi4qTgQAAyR7t5MDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2MF3WKR014171


>Basically OK, but you have lots of whitespace issues, so I can't apply
>your patch. Please resend and make sure it applies.

Sorry, I rewrite my patch here.

Signed-off-by: EunBong Song <eunb.song@samsung.com>
 ---
 drivers/i2c/busses/i2c-octeon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 935585e..b2e3259 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -183,7 +183,7 @@ static irqreturn_t octeon_i2c_isr(int irq, void *dev_id)
 	struct octeon_i2c *i2c = dev_id;
 
 	octeon_i2c_int_disable(i2c);
-	wake_up_interruptible(&i2c->queue);
+	wake_up(&i2c->queue);
 
 	return IRQ_HANDLED;
 }
@@ -206,9 +206,9 @@ static int octeon_i2c_wait(struct octeon_i2c *i2c)
 
 	octeon_i2c_int_enable(i2c);
 
-	result = wait_event_interruptible_timeout(i2c->queue,
-						  octeon_i2c_test_iflg(i2c),
-						  i2c->adap.timeout);
+	result = wait_event_timeout(i2c->queue,
+					octeon_i2c_test_iflg(i2c),
+					i2c->adap.timeout);
 
 	octeon_i2c_int_disable(i2c);
 
-- 
1.7.0.1

Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
