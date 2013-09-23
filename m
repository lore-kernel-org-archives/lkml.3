Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3IWJlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:41:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55993 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3IWJlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:41:49 -0400
X-AuditID: cbfee68e-b7f756d000004512-89-52400cdbe5b4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Derek Basehore'" <dbasehore@chromium.org>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 03/15] rtc: rtc-cmos: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:41:47 +0900
Message-id: <001f01ceb841$1f37f8f0$5da7ead0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAFv2Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zA93bPA5BBifOaFosuXiV3WLO+jVs
	Fq8272GzuLzwEqvF5V1z2Cz2d3YwOrB5zG64yOKxZ+JJNo8TM36zePRtWcXoMX3eTyaPz5vk
	AtiiuGxSUnMyy1KL9O0SuDIent/MVvCRreLqt37WBsabrF2MnBwSAiYSk1bdY4ewxSQu3FvP
	1sXIxSEksIxRYv7G7+wwRfv7b7BCJKYzSux9tYYJwvnFKHHu7i9mkCo2ATWJL18OA3VwcIgI
	6Eu0tWiA1DAL7GKUWPd9Ndg6IQFbiYnTvjKB2JwCdhJrPi8Ds4UFbCRWTlrLBmKzCKhKLJp/
	H2wzL1D9uXMnoWxBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGUG2SshoC7x6K8uxAlGEj8WS0JU
	iEjse/GOEeQcCYG37BJ/9j1iglglIPFt8iEWiFZZiU0HmCH+lZQ4uOIGywRGiVlIFs9CsngW
	ksWzkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkevt2MN48YH2IMRlo/URmKdHk
	fGD055XEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	UYHZfv7ORecPM4a/OWK+cv2P0vs7bS5OqXxiulP8KXtSVeHNgy8Ord3G96+12nWrZqpgfEHB
	YSG9N8sYnbdMvZPGwPqjULFB/9GDv48PcuTZ7jy934pTsajVIXJH1MR7+0XjLaLE9p8LLzep
	vb+s8m3OFrldmb/2lss+/3tnUY/llb5F/2dxtCqxFGckGmoxFxUnAgB+A3vt9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd3bPA5BBm/uqVosuXiV3WLO+jVs
	Fq8272GzuLzwEqvF5V1z2Cz2d3YwOrB5zG64yOKxZ+JJNo8TM36zePRtWcXoMX3eTyaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmPDy/ma3gI1vF1W/9rA2M
	N1m7GDk5JARMJPb334CyxSQu3FvP1sXIxSEkMJ1RYu+rNUwQzi9GiXN3fzGDVLEJqEl8+XKY
	vYuRg0NEQF+irUUDpIZZYBejxLrvq8EmCQnYSkyc9pUJxOYUsJNY83kZmC0sYCOxctJaNhCb
	RUBVYtH8++wgNi9Q/blzJ6FsQYkfk++xgNjMAloSm7c1sULY8hKb17xlBtkrIaAu8eivLsQJ
	RhI/FktCVIhI7HvxjnECo9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQITg3PpHcwrmqwOMQowMGoxMMbmWgfJMSaWFZcmXuIUYKDWUmE14/VIUiINyWxsiq1
	KD++qDQntfgQYzLQnxOZpUST84FpK68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGLMDgpe9a8r8kGo4T//zlWtOR/xO3zEyK5lxbL88bx3DuUzeB6G1Kr8M
	r0/Y6di7JCCrP1xHhKNxis/i6k22tzMuWXF+Sq1efrT4Ssvbb5NeZlZXOf0MurPpYK79ZUkr
	tjkVVx6Gi1mZfBaZcNvtS9SVQP31C5qYot/98nPYE573Rrp3zqqCAiWW4oxEQy3mouJEAMuC
	zjVRAwAA
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
 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 79680b1..f148762 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -595,7 +595,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 static int INITSECTION
 cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 {
-	struct cmos_rtc_board_info	*info = dev->platform_data;
+	struct cmos_rtc_board_info	*info = dev_get_platdata(dev);
 	int				retval = 0;
 	unsigned char			rtc_control;
 	unsigned			address_space;
-- 
1.7.10.4


