Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3AKO4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:56:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62143 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3AKOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:55:59 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ae-50f027fec863
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
Date: Fri, 11 Jan 2013 20:32:26 +0530
Message-id: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkSvef+ocAg0ttvBaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZbx+t56xYA9/xeI9Z5kbGM9zdzFyckgImEic
	fPqWBcIWk7hwbz1bFyMXh5DAUkaJ4317mGGKnjzsZodILGKUmLVsOjOEM5lJ4t6mfrB2NgFd
	iaa3uxhBbBEBWYnDV36DFTELPGCSuL1xHTtIQljAVeLP1FtMIDaLgKrEvLY3QEUcHLwCHhI3
	vktCbFOQeHP7GTNEiYDEt8mHWEBKJIBmbjoANlJC4ASbxNdj99gh6iUlDq64wTKBUXABI8Mq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjMBAO/3vmfQOxlUNFocYBTgYlXh4KzXfBwixJpYV
	V+YeYpTgYFYS4fVi/BAgxJuSWFmVWpQfX1Sak1p8iNEH6JKJzFKiyfnAKMgriTc0NjE3NTa1
	NDIyMzXFIawkzst46kmAkEB6YklqdmpqQWoRzDgmDk6pBsbe+fGlM5c/e/p4H4uGyS5n+fbY
	U3PiH+t4fX7Su4PrCo/eie1vfAo1VA7k6b0/aaCf1OR6eWrLPLWbdb/l7yn0F1XWLpv74P2l
	k9rG7kUifQeZK2dd2nqf0Wz7CfZX6Z3XipI3ckW4cwh4F5gfOP6MVeFE2azZ1gqt7Stm8N5q
	4/ovc1jzepoSS3FGoqEWc1FxIgCPZUrhYQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd2/6h8CDNY+tra4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj9bv1
	jAV7+CsW7znL3MB4nruLkZNDQsBE4snDbnYIW0ziwr31bF2MXBxCAosYJWYtm84M4Uxmkri3
	qZ8FpIpNQFei6e0uRhBbREBW4vCV32BFzAIPmCRub1wHNkpYwFXiz9RbTCA2i4CqxLy2N0BF
	HBy8Ah4SN75LQmxTkHhz+xnzBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw/iZ
	9A7GVQ0WhxgFOBiVeHgrNd8HCLEmlhVX5h5ilOBgVhLh9WL8ECDEm5JYWZValB9fVJqTWnyI
	0Qdo+URmKdHkfGCM5ZXEGxqbmJsam1qaWJiYWeIQVhLnZTz1JEBIID2xJDU7NbUgtQhmHBMH
	p1QDo/3U2jMdjKoMm6Xe2U3yeK7Z/LFG2vnqpWlzrKbetA6aI1nHFi9T9K3kvPFZlcMt2jr7
	5ibXfpx2XHKfpuTEPRsPf0tb0sN3jGeTIWPvCY+TW3aqpRqdnNn0fY6A6jRh6aNyJrbVXk8+
	RlxR2JqWdsOo8pxvo9Rr+2aDjazaeR9euS/50qdzVomlOCPRUIu5qDgRAPATAHqQAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v5:
 - Rebased on top of latest patches:
        usb: phy: samsung: Introducing usb phy driver for hsotg (v9)
        usb: phy: samsung: Add support to set pmu isolation (v6)
   As a result adding hostphy enable mask and hostphy register offsets
   to driver data in order to access the HOSTPHY CONTROL register.

 - Adding member 'otg' to struct samsung-usbphy so that its consumers
   can call otg->set_host so as to make 'phy' aware of the consumer type:
	HOST/DEVICE

 - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_hcd'
   which keeps track of 'otg' of the controllers' phy. This then sets
   the host.

 - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-exynos
   to phy driver itself where based on phy_type it is called.

 - Added separate macro definition for USB20PHY_CFG register to select
   between host/device type usb link.

 - Removing unnecessary argument 'phy_type' from samsung_usbphy_set_type()
   and samsung_usbphy_cfg_sel().

 - Addressed few nits:
	-- added macro for 'KHZ'
	-- removing useless 'if' from samsung_usbphy_cfg_sel()
	-- keeping the place of clk_get intact and requesting driver
	   data before that.

Vivek Gautam (4):
  ARM: EXYNOS: Update & move usb-phy types to generic include layer
  usb: phy: samsung: Add host phy support to samsung-phy driver
  USB: ehci-s5p: Add phy driver support
  USB: ohci-exynos: Add phy driver support

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
 drivers/usb/host/ehci-s5p.c                        |   81 +++-
 drivers/usb/host/ohci-exynos.c                     |   85 +++-
 drivers/usb/phy/Kconfig                            |    2 +-
 drivers/usb/phy/samsung-usbphy.c                   |  512 ++++++++++++++++++--
 include/linux/usb/samsung_usb_phy.h                |   16 +
 6 files changed, 635 insertions(+), 73 deletions(-)
 create mode 100644 include/linux/usb/samsung_usb_phy.h

-- 
1.7.6.5

