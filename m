Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3IKC0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:26:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30975 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3IKC0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:26:04 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-b8-522fd4b909f8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mike Lockwood'" <lockwood@android.com>
References: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
In-reply-to: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
Subject: [PATCH 2/3] extcon: gpio: use dev_get_platdata()
Date: Wed, 11 Sep 2013 11:26:00 +0900
Message-id: <004001ceae96$41b03f00$c510bd00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ulZa6uUhwZIzATbuZxRtBD2SFVwAAFizQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI92dV/SDDK5slbS4/uU5q8XlhZeA
	xK45bBb/Hm1jt7jduILNgdVj2+5trB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcejxXMaC
	VvaKa49cGhh/sXYxcnJICJhINB7YzwRhi0lcuLeerYuRi0NIYBmjxIsXE5lhiqb8vsgMkVjE
	KPFh+XN2COcXo8Surf/ZQarYBNQkvnw5DGaLCGhJTOycyQRSxCwwk1Fiz7cdYAkhAVuJln0f
	gEZxcHAK2Ek03zYBMYUFLCU2PqgFMVkEVCW655WDFPMCFX+5cIEJwhaU+DH5HguIzQw0ff3O
	40wQtrzE5jVvwQZKCKhLPPqrC3GAkcTKT4+hykUk9r14xwhyjITAMXaJy91NYM+zCAhIfJt8
	iAWiV1Zi0wGodyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1StOzC0u
	zUvXS87P3cQIiciJOxjvH7A+xJgMtH4is5Rocj4wovNK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDjj9zKnCKe7/lFq3S8LWnZJM8p3vfD+FSNk
	rW2R/uTTm5SorLtMBdeYHSZ8MTyv0BG+UODRe78OszaB0o+O1sKNx1NOyN1e/SnE2kr55S3d
	oJx2vbqVwulr97QZRFTrvPqnHJT1Z9f8Pw+V3v3N60h7//+KWNdFlzlvO85pdL/YqXl3+dnz
	2UosxRmJhlrMRcWJAH6hNg7eAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd2dV/SDDM6eELW4/uU5q8XlhZeA
	xK45bBb/Hm1jt7jduILNgdVj2+5trB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFNJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmHHo8VzGglb2imuPXBoYf7F2MXJySAiYSEz5fZEZwhaTuHBvPVsX
	IxeHkMAiRokPy5+zQzi/GCV2bf3PDlLFJqAm8eXLYTBbREBLYmLnTCaQImaBmYwSe77tAEsI
	CdhKtOz7ADSWg4NTwE6i+bYJiCksYCmx8UEtiMkioCrRPa8cpJgXqPjLhQtMELagxI/J91hA
	bGag6et3HmeCsOUlNq95CzZQQkBd4tFfXYgDjCRWfnoMVS4ise/FO8YJjEKzkEyahWTSLCST
	ZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjON6fSe9gXNVgcYhRgINRiYf3hpx+
	kBBrYllxZe4hRgkOZiUR3qlOQCHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OB6aivJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgzD/6zrDgvWYd9+Km+Imu
	fR+k+eKW7mvfdc5KhE8luDQ19ZuJ9jLhv0ur9jfH3FIu6fk+6WvTqpp5YREFG9+IFr+e+Dkv
	u2F+6qNY+bMh0Z9YrT3nHmqU6voX+6liUzD7h++Vs+y5XRf8ivj1W6ZdwztWuGKz7vpyQfeQ
	vVXrL1yX+/vhiHm7EktxRqKhFnNRcSIANso1AjsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index f874c30..c4d5a19 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -78,7 +78,7 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
-	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_extcon_data *extcon_data;
 	int ret = 0;
 
-- 
1.7.10.4


