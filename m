Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaJGK6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:58:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaJGK6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:58:47 -0400
X-AuditID: cbfee68f-f791c6d000004834-c3-5433c765407f
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        jenny.tc@intel.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RFC PATCH 0/3] power: Generic interface to get battery specification.
Date: Tue, 07 Oct 2014 19:58:35 +0900
Message-id: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkQDf1uHGIwdpJphYHt2paTHryntli
	4srJzBZrv/awW3SefcJscXnXHDaLz71HGC3unjrKZnF6d4kDp8eE/k+MHjtn3WX32LxCy2Px
	npdMHptWdbJ59G1ZxeixYvV3do/Pm+QCOKK4bFJSczLLUov07RK4Mo4d/ctc8JqnouPeDeYG
	xiecXYycHBICJhIn+yewQNhiEhfurWfrYuTiEBJYyihx8tkGJpii2wcfMkMkpjNK/Hp+AMpp
	Y5KYtOsDM0gVm4COxP99N9lBbBEBBYnNvc9YQWxmge2MEnM/JYPYwgL+EguurwWq5+BgEVCV
	WHs2ACTMK+Ah8fLMZEaQsARQ65xJNiDjJQQWsUvsfDuZDaSGRUBA4tvkQywQNbISmw4wQ9wm
	KXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIEBvjpf8/6dzDePWB9iFGA
	g1GJh3eFlnGIEGtiWXFl7iFGU6ANE5mlRJPzgXGUVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxub1PNpCV7z9NnmYfwhgPyV7YoN+umyyQ/xx89C3
	pZtY29u33dK7ON3ihlL5TlOfyD8aXvut1H6qteVdyngrVNiwSHASn5biguM/StomuN9M0c19
	7xN0TOl6t7HmRZMVH6TWBkzeXVC+5o7phi2J1e7Hlkvt4VA+8WvqjWvCizn2pB9mXvlNWIml
	OCPRUIu5qDgRAP/6PERrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd3U48YhBv9e6Voc3KppMenJe2aL
	iSsnM1us/drDbtF59gmzxeVdc9gsPvceYbS4e+oom8Xp3SUOnB4T+j8xeuycdZfdY/MKLY/F
	e14yeWxa1cnm0bdlFaPHitXf2T0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5hx7Ohf5oLXPBUd924wNzA+4exi5OSQEDCRuH3wITOELSZx4d56ti5GLg4hgemM
	Er+eH2CGcNqYJCbt+gBWxSagI/F/3012EFtEQEFic+8zVhCbWWA7o8TcT8kgtrCAv8SC62uB
	6jk4WARUJdaeDQAJ8wp4SLw8M5kRJCwB1Dpnks0ERu4FjAyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYLj55n0DsZVDRaHGAU4GJV4eFdoGYcIsSaWFVfmHmKU4GBWEuG1PgYU4k1JrKxK
	LcqPLyrNSS0+xGgKtHsis5Rocj4wtvNK4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5akZqem
	FqQWwfQxcXBKNTCu6rdjyo7ZLp69996/v1ZP2w6eObg7e/UcxS4xuc47VSWyJ18eWCSmYXZR
	QSB0xUsRl3W5W9wj9x0XUkytE67leWOT8O991xc5v9c+t74JnGc1fPAiaJfcPPvX+XJ/H1zd
	Pr2ub8m8Zu1tLvV6yTfntl6rCWYwnXVe95vhlKdHuo8Ibd+e9OqfEktxRqKhFnNRcSIAdyiT
	SrUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches contains supporting generic interface to get battery specification
and of-based battery driver which use the interface.

Up to now, power supply subsystem assumes that battery's charartric data is
static and also often left as fuelgauge's role. However, fuelgauge driver or
any power_supply driver can be worked with different battery with different
implementation and battery also can be changed even in runtime.
If so, it needs to notify its change to all related power_supply drivers not
let them notice all with private way. Thus, it tries to introduce generic
interface for management of the battery specification.

In addition to, for the smart battery, this'll help to abstract battery
interface which can be varied with different batteries. (SDQ, MIPI BIF..)

Jonghwa Lee (3):
  power: core: Add generic interface to get battery specification.
  power: core: Add variables related temperature to power_supply_info.
  power: of_battery: Initial support for of-based battery specification
    driver.

 .../bindings/power_supply/of_battery.txt           |   34 +++++++
 drivers/power/Kconfig                              |    7 ++
 drivers/power/Makefile                             |    1 +
 drivers/power/of_battery.c                         |  100 ++++++++++++++++++++
 drivers/power/power_supply_core.c                  |   91 ++++++++++++++++++
 include/linux/power_supply.h                       |    9 ++
 6 files changed, 242 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/of_battery.txt
 create mode 100644 drivers/power/of_battery.c

-- 
1.7.9.5

