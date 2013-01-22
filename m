Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3AVPZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:25:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63504 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3AVPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:25:08 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-8e-50feaf52a86f
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, balbi@ti.com,
        thomas.abraham@linaro.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, p.paneri@samsung.com
Subject: [PATCH v2 0/2] ARM: Exynos5250: Enabling samsung usb phy
Date: Tue, 22 Jan 2013 21:01:18 +0530
Message-id: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkTjdo/b8Ag7YlnBaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZdy+/oKxYAJbxayTYg2ML1m6GDk5JARMJNZO
	/glli0lcuLeerYuRi0NIYCmjxJnr89hgiro+/mSHSExnlJj+fDcThDOZSWLvgy6wKjYBXYmm
	t7sYQWwRAVWJz20LwDqYBRYzSdzdOBMsISzgKPGu/TEziM0CVHTqzR1WEJtXwF3i5Z9bUHco
	SLy5/YwZpFlC4AibxIfj76AaBCS+TT4EVMQBlJCV2HSAGaJeUuLgihssExgFFzAyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIDLTT/55J72Bc1WBxiFGAg1GJh/fB/b8BQqyJZcWVuYcY
	JTiYlUR4dev/BQjxpiRWVqUW5ccXleakFh9iTAZaPpFZSjQ5HxgFeSXxhsYm5qbGppZGRmam
	pqQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBcWP8kYd/FZ4bB82S37Yma03GsRn+mSc6
	73AsbzrO8GpWQumvX8c7r9aoRjYyzzPj9mcwOHic72Pfi++5NedPt/ufXJdQbNK6V+X2+V3X
	3qk5GViuPvI6LGRJpm54cdVtaz/xiaFb76vvnHb8XPw5vlmnGt/sWufxqrWxbF6vjORnCSsP
	Wafv+UosxRmJhlrMRcWJAFKbg7t4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQd3A9f8CDL6vNre4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj9vUX
	jAUT2CpmnRRrYHzJ0sXIySEhYCLR9fEnO4QtJnHh3nq2LkYuDiGB6YwS05/vZoJwJjNJ7H3Q
	xQZSxSagK9H0dhcjiC0ioCrxuW0BO0gRs8BiJom7G2eCJYQFHCXetT9mBrFZgIpOvbnDCmLz
	CrhLvPxzC2q1gsSb28+YJzByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHMbPpHcw
	rmqwOMQowMGoxMP74P7fACHWxLLiytxDjBIczEoivLr1/wKEeFMSK6tSi/Lji0pzUosPMSYD
	bZ/ILCWanA+MsbySeENjE3NTY1NLEwsTM0vShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnV
	wKh1/pLnPOMg26QSBxm7xBtVrHwWHpvt6narnOda4au9qvuyRLaPRuc8AcGfFl/TAicyLPla
	sprvzLy8GO5rm2y1T513cf/2e9lcVeboH58/dE/8raUX7Lh3p74zz7EP3bmdGpcPbFdK59Vb
	bJ1vGd+5ZeW2/G9cv5++ZxV638OVo+3gfNliuxJLcUaioRZzUXEiANktUl2nAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
 - Putting separate device nodes for usb 2.0 phy and usb 3.0 phy
   based on separate driver for samsung usb 3.0 phy and
   samsung usb 2.0 phy:
   [PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250
   [PATCH v8 0/4] Adding usb2.0 host-phy support for exynos5250
 - Aligning as per the patch:
   usb: phy: samsung: Add support to set pmu isolation
 - Replaced phy-handle approach for PHY CONTROL registers
   to child nodes.
 - Removing AUX data entry from exynos5250 dt file.

Vivek Gautam (2):
  ARM: Exynos5250: Enabling samsung-usbphy driver
  ARM: Exynos5250: Enabling samsung-usb3-phy driver

 arch/arm/boot/dts/exynos5250.dtsi |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.6.5

