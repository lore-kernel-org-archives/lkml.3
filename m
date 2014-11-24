Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaKXOwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:52:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34740 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaKXOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:51:53 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-46-5473460636e1
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, Dan Murphy <dmurphy@ti.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 0/2] Add regulator-haptic driver
Date: Mon, 24 Nov 2014 23:50:49 +0900
Message-id: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkSJfNrTjE4OV2Q4vrX56zWhxe9ILR
	ovv0FlaLzx9a2C12NBxhtehdcJXN4uanb6wWl3fNYbOYcX4fk8WirV/YHbg8ds66y+7Rt2UV
	o8fxG9uZPD5vkgtgieKySUnNySxLLdK3S+DKOHWrnaXgOkfF3l1vmBoYr7N1MXJySAiYSKxZ
	s5wJwhaTuHBvPVCci0NIYCmjxPuzvcwwRd0HpzJDJBYxSvR+nwPltDFJHJq9GayKTUBb4vv6
	xawgtojAG0aJr5vDQYqYBeYzSnRPnQ+WEBYwlpjy/Sc7iM0ioCqxcDKEzSvgIdF+dzlLFyMH
	0DoFiTmTbEB6JQT62SWaX8+AqheQ+Db5EFSNrMSmA1DXSUocXHGDZQKj4AJGhlWMoqkFyQXF
	SelFJnrFibnFpXnpesn5uZsYgcF8+t+zCTsY7x2wPsQowMGoxMP7YWNRiBBrYllxZe4hRlOg
	DROZpUST84Exk1cSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsapF3l2Ldh6yr0geMd0D9WPJqfupYd2O7K9an1xtUbiC0eM2NqQ1ylMxRHVVw17XN3Y
	kwu4FK8rWh6bf+dxas6XZ6kCJi8uzrsha/hGe5mH9nqOaK195wv2vj4o1f97o8GpMu4gIT7f
	Zzs9C0Med93SdLvt++PJk4/n9d+qN7kfOGe/+OkUUUUlluKMREMt5qLiRAC1Q7DfYQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAV02t+IQg2tbNS2uf3nOanF40QtG
	i+7TW1gtPn9oYbfY0XCE1aJ3wVU2i5ufvrFaXN41h81ixvl9TBaLtn5hd+Dy2DnrLrtH35ZV
	jB7Hb2xn8vi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8apW+0s
	Bdc5KvbuesPUwHidrYuRk0NCwESi++BUZghbTOLCvfVAcS4OIYFFjBK93+cwQzhtTBKHZm8G
	q2IT0Jb4vn4xK4gtIvCGUeLr5nCQImaB+YwS3VPngyWEBYwlpnz/yQ5iswioSiycDGHzCnhI
	tN9dztLFyAG0TkFiziSbCYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx8ozqR2M
	KxssDjEKcDAq8fB+2FgUIsSaWFZcmXuIUYKDWUmEV0ysOESINyWxsiq1KD++qDQntfgQoynQ
	8onMUqLJ+cA4ziuJNzQ2MTOyNDI3tDAyNlcS571xMzdESCA9sSQ1OzW1ILUIpo+Jg1OqgVFy
	2/QJRpOaBaZL3M1vUu26LscWwfF75bNjR2/NLW438FnyPrf4+ZnAMuMrR1NXc736tePbZfbd
	zkIHjLpcctfqn1wdGTFF/8o37r2P7no4s5fzrdWu/WQedejl95tm/Qnff6w7VCT1xVzzXGv0
	ilDRTmeLHYf5vhQzb7uv+q7u1/ZcCSbJI7xKLMUZiYZazEXFiQAgr9hFqwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Changes in v2:
  - remove driver owner
  - merge enable/disable function
  - support platform data
  - fix wrong suspends_state check in regulator_haptic_resume()

Jaewon Kim (2):
  Input: add regulator haptic driver
  ARM: dts: Add regulator-haptic device node for exynos3250-rinato

 .../devicetree/bindings/input/regulator-haptic.txt |   24 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |    7 +
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
 include/linux/input/regulator-haptic.h             |   30 +++
 6 files changed, 320 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/input/regulator-haptic.h

-- 
1.7.9.5

