Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3EFEjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:39:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34711 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3EFEjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:39:42 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-cd-5187340b3afa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Alexander Clouter'" <alex@digriz.org.uk>
Subject: [PATCH 3/4] hwrng: timeriomem - remove unnecessary
 platform_set_drvdata()
Date: Mon, 06 May 2013 13:39:38 +0900
Message-id: <004801ce4a13$b7853ec0$268fbc40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KE6Iom5LjHSXcTAuF2l3mhzRM1Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zfV1uk/ZAg7vzBSw6mkMsul/JWFxe
	eInV4vKuOWwWC7b1MTqweqybN5fNY9sBVY++LasYPfpebmD0+LxJLoA1issmJTUnsyy1SN8u
	gSvj31u7grscFTtbbzA1MG5m72Lk5JAQMJFo+vudFcIWk7hwbz1bFyMXh5DAMkaJZ3tnMsEU
	7W5vZ4RILGKU2DRrNTuE84tRYtbzv8wgVWwCahJfvhwGGysioCfRt74RrINZYAKjxIwfr8CK
	hAVCJFbN3gFkc3CwCKhKTJ6jDBLmFbCUmDTvKiuELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVv
	mSEuUpDYcfY1I8yuE6duQdWISOx78Q5sr4TALnaJOa0QQ1kEBCS+TT7EArJXQkBWYtMBqDmS
	EgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihERd
	3w7GmwesDzEmA62fyCwlmpwPjNq8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTDO2mx1N+IQ50kdS/5s/rWC+/vvzH8mJf2j6Zvn/3fzOc5sTBdl
	+NbsrhrH9eIzg/a/2NSXvVw7zQok1y5Tj/dd4H0/q5ZhRdTX/XEeF/mnzFLb8XDBJqElTI+3
	anrrBUXeMrTkuHAvYan6ZA3/nntchz7v1u8KOzXzQazGnNgps/s+fq132zFBiaU4I9FQi7mo
	OBEAWnPdbNACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAV0uk/ZAg+M71S06mkMsul/JWFxe
	eInV4vKuOWwWC7b1MTqweqybN5fNY9sBVY++LasYPfpebmD0+LxJLoA1qoHRJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdotZJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4x499bu4K7HBU7W28wNTBuZu9i5OSQEDCR2N3ezghh
	i0lcuLeerYuRi0NIYBGjxKZZq9khnF+MErOe/2UGqWITUJP48uUwWLeIgJ5E3/pGRpAiZoEJ
	jBIzfrwCKxIWCJFYNXsHkM3BwSKgKjF5jjJImFfAUmLSvKusELagxI/J91hAbGYBLYn1O48z
	QdjyEpvXvGWGuEhBYsfZ14wwu06cugVVIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4pp9J7WBc2WBxiFGAg1GJh7fgSVugEGtiWXFl7iFG
	CQ5mJRFen71AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hppu8knhDYxMzI0sjMwsjE3Nz
	0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamC0+sAWuCmc5fEv3htiSkmOhmpOq+7un+XW
	5lW6+u/duKLHAncWi+ZP63o+IdzH+fYjXhnnos6zX58l/ruo2cpun3uiaX2H07FNmbcvqSyY
	YH64c579gn92Ex4Ze+ydeGOZJs/Lu7on+aaIHPFYl7I06WAHwwpGsUij2PuvLV5e8V15aU/V
	Jg4bJZbijERDLeai4kQA6AdeBS0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/timeriomem-rng.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 3e75737..d2120ba 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -192,7 +192,6 @@ out_release_io:
 out_timer:
 	del_timer_sync(&priv->timer);
 out_free:
-	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
 	return err;
 }
@@ -209,7 +208,6 @@ static int timeriomem_rng_remove(struct platform_device *pdev)
 	del_timer_sync(&priv->timer);
 	iounmap(priv->io_base);
 	release_mem_region(res->start, resource_size(res));
-	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
 
 	return 0;
-- 
1.7.2.5


