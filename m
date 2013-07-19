Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775Ab3GSHQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:16:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49925 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727Ab3GSHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:16:04 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-0b-51e8e7b46440
From: Jingoo Han <jg1.han@samsung.com>
To: "'Evgeniy Polyakov'" <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] w1: replace strict_strtol() with kstrtol()
Date: Fri, 19 Jul 2013 16:16:03 +0900
Message-id: <001401ce844f$d4047db0$7c0d7910$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ET9PZdBmTUcBHTFOyLh1FhosXqw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zY90tz18EGhyaxWRxeeElVovLu+aw
	WfxafY7Ngdnj8Y7tTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcf/nb/aChxwV049LNjA2
	s3cxcnJICJhItL1YxAZhi0lcuLceyObiEBJYxijxa+F0Npiiq8umQCUWMUqsfPCLGcL5xSix
	9tEnsFFsAmoSX74cBrNFBDQk1jd9YgKxmQWcJH5umckCYgsLWEscu3wdrIZFQFWis72PEcTm
	FbCUWNbQCWULSvyYfI8FoldLYv3O41Bz5CU2r3nLDHGRgsSOs68ZIXbpSfT8fMUMUSMise/F
	O0aImnnsEt/e2UDsEpD4NvkQ0EwOoLisxKYDUGMkJQ6uuMEygVFsFpLNs5BsnoVk8ywkGxYw
	sqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECImo3h2Mtw9YH2JMBlo/kVlKNDkfGJF5JfGG
	xmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAsCt+TvFb4
	4V6jf++6Nj6KzTTaXtnx+ajn5MP2j368ebU66p1jk4rCg+UhRm7v48+LpWRa+bzbay7KOSdR
	Ze4Jlls/np1TfetU/S/rWf2ahFoB/1kZB+ZdsChO+LKHj2vCPd2Damun6t43k+rImujtznCs
	OG8b46THnvv/XAu/XnJi8krHiNbvSizFGYmGWsxFxYkAcAyH674CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgO7m5y8CDd5ft7a4vPASq8XlXXPY
	LH6tPsfmwOzxeMd2Jo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wB2qSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxjzLj/8zd7wUOOiunHJRsYm9m7GDk5JARMJK4um8IGYYtJXLi3Hsjm4hASWMQosfLB
	L2YI5xejxNpHn8A62ATUJL58OQxmiwhoSKxv+sQEYjMLOEn83DKTBcQWFrCWOHb5OlgNi4Cq
	RGd7HyOIzStgKbGsoRPKFpT4MfkeC0SvlsT6nceh5shLbF7zlhniIgWJHWdfM0Ls0pPo+fmK
	GaJGRGLfi3eMExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnDEPpPawbiyweIQowAHoxIP74MvzwOFWBPLiitzDzFKcDArifD+Sn4RKMSbklhZlVqUH19U
	mpNafIgxGejTicxSosn5wGSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2MDCby3KIfTyywcH7DvnlV07p3twL2t4luc/j47aNIZ8UEh+/7ihl15wq+id/P
	fk9fk0n90rWKXwdWZaZJR5tbJqeqZ/0yLCtKmrpM4snxhLj0qiAWlWu6/tqbOA87fRadl/sr
	V9mzaL2RS0C27gRGsZbAzzmu54W/CxyZoD2L95XMurUXdLcrsRRnJBpqMRcVJwIAqOMhGxwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtol() is not preferred, because
strict_strtol() is obsolete. Thus, kstrtol() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/w1/w1.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 0459df8..46a8fd7 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -235,9 +235,11 @@ static ssize_t w1_master_attribute_store_search(struct device * dev,
 {
 	long tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
+	int ret;
 
-	if (strict_strtol(buf, 0, &tmp) == -EINVAL)
-		return -EINVAL;
+	ret = kstrtol(buf, 0, &tmp);
+	if (ret)
+		return ret;
 
 	mutex_lock(&md->mutex);
 	md->search_count = tmp;
@@ -267,9 +269,11 @@ static ssize_t w1_master_attribute_store_pullup(struct device *dev,
 {
 	long tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
+	int ret;
 
-	if (strict_strtol(buf, 0, &tmp) == -EINVAL)
-		return -EINVAL;
+	ret = kstrtol(buf, 0, &tmp);
+	if (ret)
+		return ret;
 
 	mutex_lock(&md->mutex);
 	md->enable_pullup = tmp;
-- 
1.7.10.4


