Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaGJEXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:23:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40824 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaGJEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:23:49 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7fb56d000003439-a9-53be1553ce94
Content-transfer-encoding: 8BIT
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.szyprowski@samsung.com, broonie@linaro.org,
        tobetter@gmail.com, jy0922.shim@samsung.com
Subject: [PATCH 1/3] usb: usb3503: fix build warning
Date: Thu, 10 Jul 2014 13:23:46 +0900
Message-id: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkUDdYdF+wwZ77Khabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRXDYpqTmZZalF+nYJXBkf595kLdjDXnHgxzKmBsaJbF2MnBwSAiYSb9//YYSwxSQu3FsP
	FOfiEBJYyijx7f0dJpiiV7dPQyUWMUp8nnCGBSTBKyAo8WPyPSCbg4NZQF7iyKVskDCzgLrE
	pHmLmCHqW5kkXqx4A1bPJqAncWfbcSaQehEBa4m+g0EQ9dUS/9ffA9slDLTr94kXYOUsAqoS
	66dMZ4dY5S5xam0fC8Q9ChI/L58Au0dCYB27xLcTrYwQDQIS3yYfArtHQkBWYtMBZoh6SYmD
	K26wTGAUmYXk6lkIV89CcvUCRuZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIExdPrfswk7
	GO8dsD7EmAy0cSKzlGhyPjAG80riDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBsfPN4bJuxclbtHfd+pnNsSPCbPMSmWsKDxq/7lHY+mLJ7elex8O+
	6nRniPpVavGd3mD46Mdd54Wr1jFt3/j/wo3PfL0OMS8TtlQKOdwt+NBQWj2/OUL9566fAXq5
	Im0HF/4/yP9jSWRs+hWmM/s1tc32POB+7Rv02if7Qr/Vsglr91vtW6OvNFuJpTgj0VCLuag4
	EQDdjPSLtwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd1g0X3BBp9fylpsun6d1aJ58Xo2
	ixf3LrJYXN41h81i0bJWZou1R+6yW+x7vIbZgd1j56y77B53ru1h89g/dw27R9+WVYwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+Dj3JmvBHvaKAz+WMTUw
	TmTrYuTkkBAwkXh1+zSULSZx4d56IJuLQ0hgEaPE5wlnWEASvAKCEj8m3wOyOTiYBeQljlzK
	BgkzC6hLTJq3iBmivpVJ4sWKN2D1bAJ6Ene2HWcCqRcRsJboOxgEUV8t8X/9PSYQWxho7+8T
	L8DKWQRUJdZPmc4Oscpd4tTaPhaIexQkfl4+wTaBkW8WkitmIVwxC8kVCxiZVzGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIER+gz6R2MqxosDjEKcDAq8fA29OwNFmJNLCuuzD3EKMHBrCTC
	6/EfKMSbklhZlVqUH19UmpNafIjRFOjAicxSosn5wOSRVxJvaGxiZmRpZG5oYWRsriTOe7DV
	OlBIID2xJDU7NbUgtQimj4mDU6qB0Tvq0mGTH9XyGatmxDp7irtFKzKtDBcIb2n+3VzzMlSd
	u8BzZ7ioyNG5+7a4ioWte3DW47P84Qda5pm7gru4aoSaQyonRL0LUvTVnWHqalSlMC07aPr/
	jQVGWxmtJziqtjfdOj5ZllkgZtPXmILI3yWq97Ze+WV8fa303Y2K3ectXacwzndSYinOSDTU
	Yi4qTgQADctft+YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build warning.

drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    dev_err(dev, "unable to request refclk (%d)\n", err);
           ^
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/usb/misc/usb3503.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index f43c619..652855b 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
 
 		clk = devm_clk_get(dev, "refclk");
 		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
-			dev_err(dev, "unable to request refclk (%d)\n", err);
+			dev_err(dev, "unable to request refclk (%ld)\n",
+					PTR_ERR(clk));
 			return PTR_ERR(clk);
 		}
 
-- 
1.8.1.2

