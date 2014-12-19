Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaLSCri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:47:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58369 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaLSCrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:36 -0500
X-AuditID: cbfee691-f79b86d000004a5a-fe-549391c65273
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND V2 0/10] Improve charger manager driver for optimized
 operation.
Date: Fri, 19 Dec 2014 11:47:20 +0900
Message-id: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkSPfYxMkhBrs6FC0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZTT8WMpWsJO34sSkP+wN
	jPu5uhg5OSQETCS2T9rNCmGLSVy4t56ti5GLQ0hgKaPE06c7WWCKfu99wQ6RWMQosf3rLCYI
	p41J4sure0wgVWwCOhL/991kB7FFBBQkNvc+YwUpYha4wihxc/F6sCJhgUiJOcv+sIHYLAKq
	Eicb14Ht5hVwl2i9tYqxi5EDaJ2CxJxJNiC9EgLL2CVWbPrDBFEvIPFt8iEWiBpZiU0HmCGu
	k5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAoP89L9nE3cw3j9gfYhR
	gINRiYf3QfHkECHWxLLiytxDjKZAGyYyS4km5wNjKa8k3tDYzMjC1MTU2Mjc0kxJnFdH+mew
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYFIhf+L0u8vG1qg6Di6ftarit+JG9t4Npz6tCZ
	CWaV3bo1bbKOSv/+9J55VPWY44OF8/4ch9TY78qffqeFcCrOVF+33mDrlUNaUqrCv66dZLtU
	+r3T187ZNnaf3cM3Jglf1SSuSYVPyWF6zs6mvqz93/r7q96kVp4+yHJ22zODqj3GX/8vOnJG
	iaU4I9FQi7moOBEAEKQn6G0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jAd1jEyeHGByeI2FxcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLS7vmsNm8bn3CKPF7cYVbBZ3Tx1lszi9u8SBy2NC/ydGj52z7rJ7
	bF6h5bFpVSebR9+WVYweK1Z/Z/f4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWNGw4+lbAU7eStOTPrD3sC4n6uLkZNDQsBE4vfeF+wQtpjEhXvr2boYuTiEBBYx
	Smz/OosJwmljkvjy6h4TSBWbgI7E/303wTpEBBQkNvc+YwUpYha4wihxc/F6sCJhgUiJOcv+
	sIHYLAKqEicb17GC2LwC7hKtt1YxdjFyAK1TkJgzyWYCI/cCRoZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMEx9Ex6B+OqBotDjAIcjEo8vB2Fk0OEWBPLiitzDzFKcDArifCaZwKFeFMS
	K6tSi/Lji0pzUosPMZoCLZ/ILCWanA+M77ySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU
	7NTUgtQimD4mDk6pBsaY6B5fM4sLnUX+n04HlASzPIy/fuzUpXnaGQfu7vI//P+DzPobsXcf
	M/GzZYiVcVs1l1tEHZdiYjRRcX8hOHmDfsyT31MO8FxIumWtXfLr7uZ1tSfXGNgd64thZeW/
	eoDp0TPNFZvrf83TfnFn7r9tL9Z8e+xwNOfL7zsr/MynPr7ca7VJ9KOGEktxRqKhFnNRcSIA
	fLaSrLcCAAA=
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

[Changes in V2]
- Rebase patch series on latest of battery-2.6.git.
- Seperate 'power: charger-manager: Rearrange data and monitor ~' patch into
  several patches depends on its purpose.
- Add 2 patches related with polling mode.

Jonghwa Lee (10):
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
 drivers/power/Kconfig                              |    1 +
 drivers/power/charger-manager.c                    |  758 ++++++--------------
 include/linux/power/charger-manager.h              |   34 +-
 4 files changed, 219 insertions(+), 575 deletions(-)

-- 
1.7.9.5

