Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaLSIzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:55:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaLSIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:33 -0500
X-AuditID: cbfee68e-f79b46d000002b74-67-5493e8000adb
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 0/11] Improve charger manager driver for optimized operation.
Date: Fri, 19 Dec 2014 17:55:12 +0900
Message-id: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkSJfhxeQQgxfb5S0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZXy/eYap4A1fxe1Ncxgb
	GM9xdzFyckgImEhM6bvPBGGLSVy4t56ti5GLQ0hgKaPEq2enWGGKvr1pBbOFBKYzSvQsrIIo
	amOS+NHRxgKSYBPQkfi/7yY7iC0ioCCxufcZK0gRs8AVRombi9eDrRAWCJBYuW0XG4jNIqAq
	MXvzHbAGXgF3iVtnfgLZHEDbFCTmTLIB6ZUQWMYuMWP/PyaIegGJb5MPsUDUyEpsOsAMcZyk
	xMEVN1gmMAouYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREY4qf/PevbwXjzgPUhRgEO
	RiUe3o7CySFCrIllxZW5hxhNgTZMZJYSTc4HRlJeSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2MjhOm/dxwZoeL6OZv03fZN31/ej0qy8RQ9vZ/Fqsv
	P43+muXVyrZF9qpc2uncf9f/T3RbkJedRZOnEPeRj9dNa62XC2yxyWU/or8yRonRML/HxvnV
	02vzxV2zmeKuvpUrYVYXim9cVKMUnriz4IEn0/OP819O5L2/eZP18il/X//QidFV29amxFKc
	kWioxVxUnAgAIRowUmwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQV2GF5NDDM6uFbc4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHj+80zTAVv+Cpub5rD2MB4jruLkZNDQsBE4tubVlYIW0ziwr31bCC2kMB0Rome
	hVVdjFxAdhuTxI+ONhaQBJuAjsT/fTfZQWwRAQWJzb3PWEGKmAWuMErcXLyeCSQhLBAgsXLb
	LrBJLAKqErM33wFr4BVwl7h15ieQzQG0TUFiziSbCYzcCxgZVjGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIER9AzqR2MKxssDjEKcDAq8fB2FE4OEWJNLCuuzD3EKMHBrCTC63gcKMSbklhZ
	lVqUH19UmpNafIjRFGj5RGYp0eR8YHTnlcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGan
	phakFsH0MXFwSjUw2ra8vH1s1YOC05ucZjk0CP+x6p1yoYFx2+ITsyc96Jx0K+vL4UkWysH9
	YWo3vqntnhdSk3Zo0vsVFjr3OmbNqbywXL190qs/h28F2+26ata65eA+Qe0uRxvFj7+Dufd8
	3L3eZvc7yT+3Pp26U/av+fyKy/Lid+ce2fziUbdhcLFUAq/Sk7MXTisqsRRnJBpqMRcVJwIA
	Sx/ikrYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After charger manager's initially introduced, it has kept its codes without any
big change. However, the charger manager working operation isn't optimized and
it also has unused codes and non-generic interface. This series tries to make
charger manager more generic and maintainable with some fixes.

[Changes in V3]
- Add omitted patch '[1/11] Use alarmtimer for battery~' from v2 patch set.

[Changes in V2]
- Rebase patch series on latest of battery-2.6.git.
- Seperate 'power: charger-manager: Rearrange data and monitor ~' patch into
  several patches depends on its purpose.
- Add 2 patches related with polling mode.

Jonghwa Lee (11):
  power: charger-manager: Use alarmtimer for battery monitoring in
    suspend.
  power: charger-manager: Use thermal subsystem interface only to get
    temperature.
  power: charger-manager: Use power_supply_changed() not private
    uevent.
  power: charger-manager: Remove deprecated function,
    cm_notify_event().
  power: charger-manager: Fix to use CHARGE_NOW/FULL property
    correctly.
  power: charger-manager: Concentrate scattered power_supply_changed()
    calls.
  power: charger-manager: Get external power souce information only
    from EXTCON.
  power: charger-manager: Make chraging decision focusing on battery
    status.
  power: charger-manager: Not to start charging directly in cable
    nofitication.
  power: charger-manager: Support different polling mode for sleep
    state.
  power: charger-manager: Support to change polling rate in runtime.

 .../bindings/power_supply/charger-manager.txt      |    1 -
 drivers/power/Kconfig                              |    3 +-
 drivers/power/charger-manager.c                    | 1026 ++++++--------------
 include/linux/power/charger-manager.h              |   66 +-
 4 files changed, 293 insertions(+), 803 deletions(-)

-- 
1.7.9.5

