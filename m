Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbbAFFpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:45:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54412 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbbAFFpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:45:21 -0500
X-AuditID: cbfee691-f79b86d000004a5a-e4-54ab766f7983
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH RESEND 0/3] power: rt5033: Add Richtek RT533 drivers
Date: Tue, 06 Jan 2015 14:45:14 +0900
Message-id: <1420523117-6814-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQDe/bHWIwbepghanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5Vov+NwtZLc69WsloMen+BBaL93vOMFpc3jWHzeJz7xFGi6XXLzJZ
	TJi+lsWide8RdovTu0ssZkx+yeYg4LFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	6NuyitHj8ya5AI4oLpuU1JzMstQifbsEroy7vWeZCo5xVvxbdYytgXEFexcjJ4eEgInE6Quz
	WSFsMYkL99azdTFycQgJLGWU2Nt2kxWmaPKi9awQiemMEtOePWGEcNqYJPb1/werYhPQlHg/
	5QoLiC0iECFxdtksFpAiZoFtQEUX/zGCJIQFXCQeb5sMtIODg0VAVeL2CxWQMK+Aq8TzjrvM
	IGEJAQWJOZNsIBbfYpdYuM4PxGYREJD4NvkQC0SJrMSmA8wQJZISB1fcYJnAKLiAkWEVo2hq
	QXJBcVJ6kalecWJucWleul5yfu4mRmCsnP73bOIOxvsHrA8xCnAwKvHwepxYGSLEmlhWXJl7
	iNEUaMNEZinR5HxgROaVxBsamxlZmJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cBoEzPP6evWDjMtntyl23iYpZ0KfwUnH7uS9KlZ3S76ePRNP/u3Wo86WP46MzIo
	q/u+mN5rJmG9VC7me26C4c/83gt1lzVaLLOb1q819HX+ZhunvMIhZIGdx6HdEyMMjt3gvimo
	77Z57dLofWuTZR7E9xd3NnBtY73EbcmgoOt+c6rUeaUQUSWW4oxEQy3mouJEAPrEERuQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd38stUhBouPc1ic/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC363yxktTj3aiWjxaT7E1gs3u85w2hxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y6xmDH5JZuDgMeaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	o2/LKkaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22V
	XHwCdN0yc4BeUFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3O09y1Rw
	jLPi36pjbA2MK9i7GDk5JARMJCYvWs8KYYtJXLi3nq2LkYtDSGA6o8S0Z08YIZw2Jol9/f/B
	qtgENCXeT7nCAmKLCERInF02iwWkiFlgG1DRxX+MIAlhAReJx9smA43i4GARUJW4/UIFJMwr
	4CrxvOMuM0hYQkBBYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfiM+kd
	jKsaLA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhHfH51UhQrwpiZVVqUX58UWlOanFhxhN
	gXZPZJYSTc4Hpom8knhDYxMzI0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQbG
	DR1P+qymSa/w+pB0yujGoQxfa5PPb84uXrxFY7PS44x7Mnu3XnYt3q3blZK5OaY0+rGejvSu
	v06372z+smxbYYnOsavx+5r2pwXWfQxpyuU99+nP3ZwY3TqBY0t9ldsCHjdMXzAjWGjPsk55
	rztLN5y23/vwN7e/ZvA6V+VzZV7ubTI5n+O2KbEUZyQaajEXFScCALh8FQzbAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds driver for Richtek rt5033 chip The chip contains
switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
Additionally, This includes document for device tree of RT5033 device.

RT5033 core driver is applied by Lee Jones.
RT5033 regulator driver have been merged by Mark Brown. commit is below,

commit b1917578fd5d8efa67afa05a0d6d7e323f2802da

Beomho Seo (3):
  power: rt5033_battery: Add RT5033 Fuel gauge device driver
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 6 files changed, 789 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c

-- 
1.7.9.5

