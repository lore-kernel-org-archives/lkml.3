Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbaCQMDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:03:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbaCQMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:03:00 -0400
X-AuditID: cbfee68f-b7f156d00000276c-29-5326e4721a3a
From: Girish K S <ks.giri@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, s-anna@ti.com, ilho215.lee@samsung.com,
        Girish K S <ks.giri@samsung.com>
Subject: [PATCH 0/2] Support for samsung mailbox controller
Date: Mon, 17 Mar 2014 17:33:57 +0530
Message-id: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkRrfoiVqwweR1Jhbzj5xjtTj6byGj
	xbUVc9kt5h/dwWSx6fE1VovLu+awWez9tY/Vgd1j56y77B6bl9R79G1Zxehx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mr59fsFaMIm94s+kqawNjH2sXYycHBICJhKLX/WwQdhiEhfurQey
	uTiEBJYySjxYspUJpmjSisOsEIlFjBJfP29nhnA6mCTmXFgBNopNQE1i47r77CC2iECKxKz3
	i1hAbGaBDIn/h5YxgtjCAtYSsz9eAqthEVCV2P50JjOIzSvgLLHo+gyobYoS3c8mgJ0hIfCf
	TWL79DeMEA0CEt8mHwIaygGUkJXYdIAZol5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLWK07M
	LS7NS9dLzs/dxAgM29P/nvXvYLx7wPoQYzLQuInMUqLJ+cCwzyuJNzQ2M7IwNTE1NjK3NCNN
	WEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjO0cM5ue/G7d2Fla4a+yb0fb8bO/
	FnD/Zcp515gtuXmCV6mr1v9VMiUzcxyWTa/LKW9fH3zvxcS4HQxqNbOeSi57tvznw49vT+1w
	YPy2WeB4neqZLw27XZLnN381FH4ok5JiJ/lh29oFLB7CFpwX9UwyrhunThP89PfD+ZeCVrO4
	ty6t23//F7sSS3FGoqEWc1FxIgBxjc0WcQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd2iJ2rBBku+aVvMP3KO1eLov4WM
	FtdWzGW3mH90B5PFpsfXWC0u75rDZrH31z5WB3aPnbPusntsXlLv0bdlFaPH8RvbmTw+b5IL
	YI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpD
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx7fML1oJJ7BV/Jk1lbWDs
	Y+1i5OSQEDCRmLTiMJQtJnHh3nq2LkYuDiGBRYwSXz9vZ4ZwOpgk5lxYAVbFJqAmsXHdfXYQ
	W0QgRWLW+0UsIDazQIbE/0PLGEFsYQFridkfL4HVsAioSmx/OpMZxOYVcJZYdH0GE8Q2RYnu
	ZxPYJjByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHBXPpHcwrmqwOMQowMGoxMM7
	QVktWIg1say4MvcQowQHs5IIb9o1oBBvSmJlVWpRfnxRaU5q8SHGZKDtE5mlRJPzgRGbVxJv
	aGxibmpsamliYWJmSZqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MjvNLD0+46z/35qOt
	PS35XtMzA0wsDy77GPZSTSjdYn/aufBrsjt9bt8zeWQfP+/ctO5YJUbjD5EFLXNWd21h42w7
	GnCqiN9v1y7Gx8/aC6fGKmvVHqz84pxk+/o6/61+1UP3nAMW6/z4/SpQ41nvfycG/+ZJz48d
	ODblWVXaDW71ng1eu889VGIpzkg01GIuKk4EAHH+e/3OAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is based on the mailbox framework prepared by jassi
and others.  

Girish K S (2):
  mailbox: samsung: added support for samsung mailbox
  arm64: dts: exynos: added mailbox node

 .../bindings/mailbox/samsung-mailbox.txt           |   24 ++
 arch/arm64/boot/dts/samsung-gh7.dtsi               |   66 ++++
 arch/arm64/boot/dts/samsung-ssdk-gh7.dts           |    3 +
 drivers/mailbox/Kconfig                            |    8 +
 drivers/mailbox/Makefile                           |    2 +
 drivers/mailbox/mailbox-samsung.c                  |  354 ++++++++++++++++++++
 include/linux/mailbox-samsung.h                    |  112 +++++++
 7 files changed, 569 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
 create mode 100644 drivers/mailbox/mailbox-samsung.c
 create mode 100644 include/linux/mailbox-samsung.h

-- 
1.7.10.4

