Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaENTSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:18:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaENTSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:18:21 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a3-5373c17b943c
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v3 0/3] phy: Add exynos-simple-phy driver
Date: Thu, 15 May 2014 00:47:20 +0530
Message-id: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSp1t9sDjYoP0Cv8WtdedYLeYfARJX
	vr5nszjwZwejxfddX9gtehdcZbO48LSHzeJs0xt2i8u75rBZzDi/j8liyqLDrBate4+wW8z7
	vJPJYl77S1YHPo+ds+6ye2xa1cnmcefaHjaP+93HmTz6tqxi9Dh+YzuTx+dNcgHsUVw2Kak5
	mWWpRfp2CVwZB36vYSn4IFWxYMsH9gbG2aJdjJwcEgImEqtubmKCsMUkLtxbz9bFyMUhJLCU
	UWLy3WvMXYwcYEVX3sZDxKczSmz9e5AFwmlnkmjt3MoK0s0moCsx++AzRhBbRCBN4tuBFlaQ
	ImaB2UwSG1+8ZgNJCAtYSnyb95QZxGYRUJVYNGklC4jNK+AmsfhSA9Q2BYk5k2xAeiUEjrFL
	/DjWzQRRLyDxbfIhFogaWYlNB5ghrpaUOLjiBssERsEFjAyrGEVTC5ILipPSi4z1ihNzi0vz
	0vWS83M3MQIj4vS/Z/07GO8esD7EmAw0biKzlGhyPjCi8kriDY3NjCxMTUyNjcwtzUgTVhLn
	vf8wKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI9ebqflHd5szBr94YrNt1fFM3iOCUQ7d
	BlHv/+/5FFyxUJy7oMtwrZP1Do5Db+Ltf71eJ6Z33eixygGfR5VpxtaPIjpMvcsVdIzOqGQV
	Xas6K/KHd/HbtI/pn6Yf2hVlXz9L9MybZTsaXbdVrn6+b/ZFpyuaqmEmG7TvrXm4r3GtebvX
	uyfrMpRYijMSDbWYi4oTARsQ+deeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jQd3qg8XBBv8eMFncWneO1WL+ESBx
	5et7NosDf3YwWnzf9YXdonfBVTaLC0972CzONr1ht7i8aw6bxYzz+5gspiw6zGrRuvcIu8W8
	zzuZLOa1v2R14PPYOesuu8emVZ1sHneu7WHzuN99nMmjb8sqRo/jN7YzeXzeJBfAHtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLSSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePA7zUsBR+kKhZs+cDewDhbtIuRg0NC
	wETiytv4LkZOIFNM4sK99WxdjFwcQgLTGSW2/j3IAuG0M0m0dm5lBaliE9CVmH3wGSOILSKQ
	JvHtQAsrSBGzwGwmiY0vXrOBJIQFLCW+zXvKDGKzCKhKLJq0kgXE5hVwk1h8qYEZYrOCxJxJ
	NhMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI63Z1I7GFc2WBxiFOBgVOLhZZhc
	HCzEmlhWXJl7iFGCg1lJhDdpL1CINyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ+cBUkFcSb2hs
	Ym5qbGppYmFiZkmasJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjIwcfI+56l4Kxetmxhza
	FWWRysYUcjPOZTrL9u+S7NNNK1pfTwr1mqV2qvowe5nfqzk++x3c+7Vm7pBufRQjUdZUWnTI
	u6pRZj6fqIJhenevME/mz9mdW8/7/AsReuRfct9tn4SP+DH3ySxMLwJXrDj5StXHviGnauVh
	4cbuhe9XTNcMlrimxFKckWioxVxUnAgASWFOfPsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rahul Sharma <Rahul.Sharma@samsung.com>

Hi All,

This series has been originally proposed by Tomasz Stanislawski. With
his permission, I have addressed the following review comments in V3.

Changelog:
v3:
	* Implement lazy-init of PHYs.
	* Use MACROs instead of numbers to represent phys.
	* Use regmap interface to access PMU registers.

It is based on "Next" branch in Kishon Vijay Abraham's tree at
https://git.kernel.org/cgit/linux/kernel/git/kishon/linux-phy.git/

/* Original Message from Tomasz Stanislawski <t.stanislaws@samsung.com> */

The Samsung SoCs from Exynos family are enhanced with a bunch of devices that
provide functionality of a physical layer for interfaces like USB, HDMI, SATA,
etc. They are controlled by a simple interface, often a single bit that enables
and/or resets the physical layer.

An IP driver should to control such a controller in an abstract manner.
Therefore, such 'enablers' were implemented as clocks in older versions of
Linux kernel.  With the dawn of PHY subsystems, PHYs become a natural way of
exporting the 'enabler' functionality to drivers.  However, there is an
unexpected consequence. Some of those 1-bit PHYs were implemented as separate
drivers.  This means that one has to create a struct device, struct phy, its
phy provider and 100-150 lines of driver code to basically set one bit.

The DP phy driver is a good example:
https://lkml.org/lkml/2013/7/18/53

And simple-phy RFC (shares only driver code but not other resources):
https://lkml.org/lkml/2013/10/21/313

To avoid waste of resources I propose to create all such 1-bit phys from Exynos
SoC using a single device, driver and phy provider.

This patchset contains a proposed solution.

All comment are welcome.

Hopefully in future the functionality introduced by this patch may be merged
into a larger Power Management Unit (PMU) gluer driver.  On Samsusng SoC , the
PMU part contains a number of register barely linked to power management (like
clock gating, clock dividers, CPU resetting, etc.).  It may be tempting to
create a hybrid driver that export clocks/phys/etc that are controlled by PMU
unit.

Alternative solutions might be:
* exporting a regmap to the IP driver and allow the driver to control the PHY layer
  like in the patch:
  http://thread.gmane.org/gmane.linux.kernel.samsung-soc/28617/focus=28648

* create a dedicated power domain for hdmiphy

Regards,
Tomasz Stanislawski

v2:
	* rename to exynos-simple-phy
	* fix usage of devm_ioremap()
	* add documentation for DT bindings
	* add patches to client drivers

v1: initial version

Tomasz Stanislawski (3):
  phy: Add exynos-simple-phy driver
  drm: exynos: hdmi: use hdmiphy as PHY
  s5p-tv: hdmi: use hdmiphy as PHY

 .../devicetree/bindings/phy/samsung-phy.txt        |   56 ++++++
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   11 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   11 +-
 drivers/phy/Kconfig                                |    5 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/exynos-simple-phy.c                    |  189 ++++++++++++++++++++
 include/dt-bindings/phy/exynos-simple-phy.h        |   27 +++
 7 files changed, 290 insertions(+), 10 deletions(-)
 create mode 100644 drivers/phy/exynos-simple-phy.c
 create mode 100644 include/dt-bindings/phy/exynos-simple-phy.h

-- 
1.7.9.5

