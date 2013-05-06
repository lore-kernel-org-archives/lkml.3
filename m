Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3EFEia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:38:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47280 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3EFEi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:38:29 -0400
X-AuditID: cbfee691-b7fe56d000004b96-d0-518733c3f804
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Florian Fainelli'" <florian@openwrt.org>
Subject: [PATCH 2/4] hwrng: bcm63xx - remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:38:27 +0900
Message-id: <004701ce4a13$8d5a1c10$a80e5430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KE3UlOkUvjYT4SAK0/U0XGPb/Qw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI93Dxu2BBlsWWVp8e3+GxaL7lYzF
	5YWXWC0u75rDZrFgWx+jA6vHtgOqHlsWZ3j0bVnF6NH3cgOjx+dNcgGsUVw2Kak5mWWpRfp2
	CVwZZ+bVFOzhqHi6+D17A+NE9i5GTg4JAROJ3++bmSBsMYkL99azdTFycQgJLGOUuPmjiQmm
	qP3zS3aIxCJGienLHjNDOL8YJX42dLOCVLEJqEl8+XIYbKyIgJ5E3/pGRpAiZoEJjBI7D90A
	KxIW8JfYfHweM4jNIqAqcfX3HbA4r4ClxP5LyxkhbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95
	ywxxkoLEjrOvGWGWXX9xjRmiRkRi34t3YIslBHaxSyydsANqmYDEt8mHgIZyACVkJTYdgJoj
	KXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkjc
	TdzBeP+A9SHGZKD1E5mlRJPzgXGbVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbGvSIzf7hkfZoiZNDbpH76YgjjSZlIuajtHasvbDuV9XZa+o8U
	tbvJm+b0bT48h/ftpRumfmsqpm/Ry4vbtpSjYZbP8lfPukTlXn2qqOD73W/04+6zR5+i5fp4
	mBhzi5OMtxsqWexY8Y+d9bBl35cEEy92D8cHflFP7jjenF/Os99etiJM03WOEktxRqKhFnNR
	cSIAwzNfbtECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd3Dxu2BBh2HTS2+vT/DYtH9Ssbi
	8sJLrBaXd81hs1iwrY/RgdVj2wFVjy2LMzz6tqxi9Oh7uYHR4/MmuQDWqAZGm4zUxJTUIoXU
	vOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg1UoKZYk5pUChgMTiYiV9
	O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjDPzagr2cFQ8XfyevYFxInsXIyeHhICJRPvnl1C2
	mMSFe+vZuhi5OIQEFjFKTF/2mBnC+cUo8bOhmxWkik1ATeLLl8NgHSICehJ96xsZQYqYBSYw
	Suw8dAOsSFjAX2Lz8XnMIDaLgKrE1d93wOK8ApYS+y8tZ4SwBSV+TL7HAmIzC2hJrN95nAnC
	lpfYvOYtM8RJChI7zr5mhFl2/cU1ZogaEYl9L94xTmAUmIVk1Cwko2YhGTULScsCRpZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR/UxqB+PKBotDjAIcjEo8vAVP2gKFWBPLiitzDzFK
	cDArifD67AUK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w4eSVxBsam5gZWRqZWRiZmJuT
	Jqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+PknAuLvp6bprdtuvXhOd7vbO3/mEQlN3g/
	jluquS/+UYFUOAdf4qFNk6ONo2W6RP4wFqUe6vP4GfjB4WTfgzmODe+qs2NtZGc0tL/Ka2wI
	zM92tymLzKpoSa3euJjLaYYrv5SvtsxXgdbfc57POfJnqczxff9nfvu+5J7S9I9Bms6nlV5W
	1SuxFGckGmoxFxUnAgB8HYHkLgMAAA==
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
 drivers/char/hw_random/bcm63xx-rng.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index f343b7d..36581ea 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -137,7 +137,6 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 out_clk_disable:
 	clk_disable(clk);
 out_free_rng:
-	platform_set_drvdata(pdev, NULL);
 	kfree(rng);
 out_free_priv:
 	kfree(priv);
@@ -154,7 +153,6 @@ static int bcm63xx_rng_remove(struct platform_device *pdev)
 	clk_disable(priv->clk);
 	kfree(priv);
 	kfree(rng);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


