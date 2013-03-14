Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3CNKbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:31:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57868 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3CNKbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:31:13 -0400
X-AuditID: cbfee690-b7f656d0000007e3-e5-5141a6ef52b3
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v7 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Date: Thu, 14 Mar 2013 15:59:09 +0530
Message-id: <1363256951-17158-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSpft+mWOgwe2VZhYH79dbHJj9kNXi
	7LKDbBbNi9ezWfQuuMpmcXnXHDaLGef3MVksWtbKbHF+SyeTxeEVB5gsjs1YwujA7bHg8xV2
	j9kNF1k87lzbw+axf+4ado/zMxYyevRtWcXocfzGdiaPz5vkAjiiuGxSUnMyy1KL9O0SuDIu
	np/GWPCPq+LugausDYwLOLoYOTkkBEwkVtyayQphi0lcuLeerYuRi0NIYCmjxKOl99lgimY0
	9zFDJKYzSnxpncEC4Uxhklgy8ysjSBWbgK5E09tdYLaIQLrE/7v9jCBFzALHGCWmXZrEBJIQ
	FnCV+P10OguIzSKgKnHjaR+YzSvgIfH+0XOodQoSb24/A1snIbCNXWLvqvWMEA0CEt8mHwJq
	4ABKyEpsOsAMUS8pcXDFDZYJjIILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgSG/+l/
	zybsYLx3wPoQYzLQuInMUqLJ+cD4ySuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDY0KnrveZ+tRJq1bJxPJ4Mkc1ihussXwn+aTaomnd3gU88423
	CPbcnRAjItP/Znr0pwfTVeYG969eUXF0e+/D/FV1Dp4/pm3bxXj9xgmO09NVUlZsL2iasKSI
	t6E1Z/7bv8p6tQKMsk1qSxgvbyov7urmFbqzPyNDfnn1rCshtcFlF1/OYPC1VGIpzkg01GIu
	Kk4EAKUWgx2VAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQd33yxwDDf4+1LE4eL/e4sDsh6wW
	Z5cdZLNoXryezaJ3wVU2i8u75rBZzDi/j8li0bJWZovzWzqZLA6vOMBkcWzGEkYHbo8Fn6+w
	e8xuuMjicefaHjaP/XPXsHucn7GQ0aNvyypGj+M3tjN5fN4kF8AR1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx4+L5aYwF/7gq7h64ytrAuICji5GTQ0LARGJGcx8zhC0m
	ceHeerYuRi4OIYHpjBJfWmewQDhTmCSWzPzKCFLFJqAr0fR2F5gtIpAu8f9uPyNIEbPAMUaJ
	aZcmMYEkhAVcJX4/nc4CYrMIqErceNoHZvMKeEi8f/ScDWKdgsSb28+YJzByL2BkWMUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRHF3PpHYwrmywOMQowMGoxMN7oN8hUIg1say4MvcQowQH
	s5IIr6eXY6AQb0piZVVqUX58UWlOavEhxmSg7ROZpUST84GRn1cSb2hsYm5qbGppYmFiZkma
	sJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjKdbd618/rsx1Mjjruw79umRDdO+HPNpaE3Q
	rZt5PeyT8JKqzJJwvvfmknxi5z6U79UIiOUs+tS799aernUxKs99ubO+Vtpe/XeIbdG11z5P
	3IIffBdssJv+Znpq/L/SOJbF53zyGH+rnjQWLBTIOSz4uOP0/233jphHyn0q/7lXJFlruWaz
	uRJLcUaioRZzUXEiADbfNWzyAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v6:
 - Changing the file names accordingly as per
   [PATCH] usb: phy: rename all phy drivers to phy-$name.c
 - Using devm_clk_get for PHY ref clocks "ext_xtal" and "xusbxti"
 - Adding the bindings documentation for separate USB 2.0 phy and
   USB 3.0 phy.

Based on 'usb-next' plus Felipe's 'testing' branch patches;
(some 194 patches in fact ;-), on top of 3.9rc2 tag).

Tested after merging linux-samsung's 'for-next' into 'usb-next'
to verify things with recently merged common clock framework for
samsung's SoCs.

Vivek Gautam (2):
  usb: phy: samsung: Common out the generic stuff
  usb: phy: samsung: Add PHY support for USB 3.0 controller

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   76 ++-
 drivers/usb/phy/Kconfig                            |   22 +-
 drivers/usb/phy/Makefile                           |    2 +
 drivers/usb/phy/phy-samsung-usb.c                  |  726 +-------------------
 drivers/usb/phy/phy-samsung-usb.h                  |  327 +++++++++
 drivers/usb/phy/phy-samsung-usb2.c                 |  509 ++++++++++++++
 drivers/usb/phy/phy-samsung-usb3.c                 |  349 ++++++++++
 7 files changed, 1291 insertions(+), 720 deletions(-)
 create mode 100644 drivers/usb/phy/phy-samsung-usb.h
 create mode 100644 drivers/usb/phy/phy-samsung-usb2.c
 create mode 100644 drivers/usb/phy/phy-samsung-usb3.c

-- 
1.7.6.5

