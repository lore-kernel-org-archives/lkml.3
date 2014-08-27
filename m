Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaH0BPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:15:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43530 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaH0BPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:15:11 -0400
X-AuditID: cbfee68e-f79536d000000fd1-f8-53fd3115b070
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 18/18] backlight: omap1: add blank line after declarations
Date: Wed, 27 Aug 2014 10:15:01 +0900
Message-id: <005601cfc194$533a3d40$f9aeb7c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAOBOg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zfV1Rw7/BBtd7ZS2O7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErowj2+8z
	FzxnrZj37w9bA+N3li5GTg4JAROJMx8/s0LYYhIX7q1n62Lk4hASWMYose/KZiaYon8Lz7ND
	JKYzSpxunc0E4fxmlLi8uB+snU1ATeLLl8PsILaIgILE5t5nYHFmgVyJ3zNXMoLYQgK2EpcX
	rgWbyilgJzH7w3SwemEBX4k/L1+B2SwCqhJnVkPU8ALVr9w3E8oWlPgx+R4LxEwtifU7jzNB
	2PISm9e8Ze5i5AC6VF3i0V9diBOMJGY2drNDlIhI7HvxjhHkZgmBY+wS6zZMZoPYJSDxbfIh
	FoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjJC77djDePGB9iFGAg1GJh/fDgj/BQqyJZcWVuYcYTYEumsgsJZqcD4z+vJJ4
	Q2MzIwtTE1NjI3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGGMWXt4f55jJ
	+n294amlQnXXTs33aLb/L8yZtHHZy9a8D3N8hYz53uxicrFbqrb1z9mVBUf/fGRJ2LVsOv/j
	dT/dZHX7M/37Vl1ij/x6+0Xs1rvPUnmOZqsVpfeJphhEz5hqLPV9RXqjvdGUujkr387faFMg
	cyDzUfHyBR+Uuleqt++rYE7P51JiKc5INNRiLipOBABYKuubxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQV1Rw7/BBm9OSloc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZR7bfZy54zlox798ftgbG7yxdjJwcEgImEv8WnmeHsMUkLtxb
	z9bFyMUhJDCdUeJ062wmCOc3o8Tlxf2sIFVsAmoSX74cBusQEVCQ2Nz7DCzOLJAr8XvmSkYQ
	W0jAVuLywrVMIDangJ3E7A/TweqFBXwl/rx8BWazCKhKnFkNUcMLVL9y30woW1Dix+R7LBAz
	tSTW7zzOBGHLS2xe85a5i5ED6FJ1iUd/dSFOMJKY2djNDlEiIrHvxTvGCYxCs5BMmoVk0iwk
	k2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjqn0ntYFzZYHGIUYCDUYmH9+OC
	P8FCrIllxZW5hxglOJiVRHiTFf4GC/GmJFZWpRblxxeV5qQWH2I0BXp0IrOUaHI+MCHllcQb
	GpuYGVkamVkYmZibK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgZLBxb/ss0jVDxdM9Tbl1
	aW6E8qvoacGH/zRkrZw8RWxb6qFlm09L9J9mnOVmcCm6PYnl0LuCkpsL/G705fm53A+esEhk
	+7EV91zz21bNv3buTJ64SohtrpWVRqmG1vvXSatdDI0bxHTbfGL+//oo9uh94/mkxqubjWw7
	z81Qd/m+c4eIxtccJZbijERDLeai4kQAet9t1RADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/omap1_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index a0dcd88ac74f..546d94df21d5 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -120,6 +120,7 @@ static int omapbl_update_status(struct backlight_device *dev)
 static int omapbl_get_intensity(struct backlight_device *dev)
 {
 	struct omap_backlight *bl = bl_get_data(dev);
+
 	return bl->current_intensity;
 }
 
-- 
2.0.0


