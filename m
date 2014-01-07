Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaAGBad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:30:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44457 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbaAGBac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:30:32 -0500
X-AuditID: cbfee690-b7f266d00000287c-5d-52cb58b6679b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: kb3886_bl: fix incorrect placement of
 __initdata marker
Date: Tue, 07 Jan 2014 10:30:30 +0900
Message-id: <002101cf0b48$0d38a280$27a9e780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8LSA0gEKLTvq6wRRuOH6kV6zbuQQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zI91tEaeDDC6t1rCYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKODj9EUtBG0fFvJmnWRoY
	77B1MXJySAiYSHz+NpcJwhaTuHBvPVCci0NIYBmjxNNpu+CKrr6cwwqRmM4o0bf0MDOE84tR
	4vDLNrB2NgE1iS9fDrN3MXJwiAjoS7S1aICYzAIuEkeniYBUCAtESqz6s5wVxGYRUJW4+fIu
	C4jNK2Ar8WHVJ0YIW1Dix+R7YHFmAS2JzduaWCFseYnNa94yg4yUEFCXePRXFyQsIqAnMX/b
	HagSEYl9L94xglwmIbCKXeLo5Z/MELsEJL5NPsQC0SsrsekAM8RbkhIHV9xgmcAoNgvJ5llI
	Ns9CsnkWkhULGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoTE04QdjPcOWB9iTAZaP5FZ
	SjQ5HxiPeSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAKLI8pSBo0VvptIBPnQbmezQvpP1du2Cu+u2bJziecPOYMNz5EXAv7/7dh0n2U5Z+MCqv
	KXgx+cAcxvls98852pc9Zv54W989bNfhELaXie7cO+d+U/jdITlNPsXqfdsB3iVM164eM/b0
	fZdZyrX2ieDZN0umGtr7zb2ywMuovO38jagmrf0yF5RYijMSDbWYi4oTAQRM8Yq9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoO62iNNBBjv2q1jMWb+GzeLywkus
	Fpd3zWFzYPY4MeM3i0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZhyc/oiloI2jYt7M0ywNjHfYuhg5OSQETCSuvpzDCmGLSVy4tx4ozsUhJDCdUaJv
	6WFmCOcXo8Thl21MIFVsAmoSX74cZu9i5OAQEdCXaGvRADGZBVwkjk4TAakQFoiUWPVnOdhM
	FgFViZsv77KA2LwCthIfVn1ihLAFJX5MvgcWZxbQkti8rYkVwpaX2LzmLTPISAkBdYlHf3VB
	wiICehLzt92BKhGR2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHK3PpHcwrmqwOMQowMGoxMP7Yu+pICHWxLLiytxDjBIczEoivCJKp4OEeFMS
	K6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YSPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCe
	WJKanZpakFoEs4WJg1OqgVHijtD0m9ebrmx1Yv4xy9PvUXDy4gqGmycPeYoUbG83kXkhz7Bu
	e+4Xo+t3o3jPd1rqzLpxXt8nXeNXrsAm9TX225dJsS8oj+N6szO4aE37pIyafNWNc2c3fd7q
	fm71tpozh7i+fLL4uLrFq70j0P7mxNVTf6Zd+rBT49KeUtbVj0NEXGJZvjEqsRRnJBpqMRcV
	JwIAobYF9BoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __initdata marker can be virtually anywhere on the line,
EXCEPT right after "struct". The preferred location is before
the "=" sign if there is one, or before the trailing ";" otherwise.
It also fixes the following chechpatch warning.

  WARNING: __initdata should be placed after kb3886bl_device_table[]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/kb3886_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index 7592cc2..84a110a 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -78,7 +78,7 @@ static struct kb3886bl_machinfo *bl_machinfo;
 static unsigned long kb3886bl_flags;
 #define KB3886BL_SUSPENDED     0x01
 
-static struct dmi_system_id __initdata kb3886bl_device_table[] = {
+static struct dmi_system_id kb3886bl_device_table[] __initdata = {
 	{
 		.ident = "Sahara Touch-iT",
 		.matches = {
-- 
1.7.10.4


