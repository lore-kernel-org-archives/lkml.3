Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbaJ3Mn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45008 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759800AbaJ3MnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:22 -0400
X-AuditID: cbfee68e-f79b46d000002b74-f9-54523267633e
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V2 0/10] Improve charger manager driver for optimized operation.
Date: Thu, 30 Oct 2014 21:43:06 +0900
Message-id: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkUDfDKCjEYPEEVouDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGQ0/lrIV7OStODHpD3sD
	436uLkZODgkBE4mntz8wQdhiEhfurWfrYuTiEBJYyiixbe5sZpiiy68uMkMkFjFK3OlcyQrh
	tDFJ7DuzjhGkik1AR+L/vpvsILaIgILE5t5nYEXMAlcYJW4uXg+2Q1ggQKJ57zEwm0VAVWLF
	3bmsIDavgIfEiZdXgGwOoHUKEnMm2YD0SggsYpfo3b6IDaJeQOLb5EMsEDWyEpsOQF0nKXFw
	xQ2WCYyCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIEBvnpf8/6djDePGB9iFGAg1GJ
	h1fjRGCIEGtiWXFl7iFGU6ANE5mlRJPzgbGUVxJvaGxmZGFqYmpsZG5ppiTOmyD1M1hIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY8vJdeIVofs53wZa19v2K2vEzdXff3qxUVHdpM2z7iye
	+Vc+97q0lHXyO9vofQbLJ/itXHZqy/KzshbfHwUFdF0Js26L/eNrKfjfhKtbVEd+3ctDQlPL
	Hr9+UXLF9ThjyC3nHtelr232Cyq95Th83jDxlIKcoaIlH5OtUK+e49JFc6Qn78lyV2Ipzkg0
	1GIuKk4EAPrEaz9tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jAd10o6AQg++3LS0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcxo+LGUrWAnb8WJSX/YGxj3c3UxcnJICJhIXH51kRnCFpO4cG89WxcjF4eQwCJG
	iTudK1khnDYmiX1n1jGCVLEJ6Ej833eTHcQWEVCQ2Nz7DKyIWeAKo8TNxeuZQBLCAgESzXuP
	gdksAqoSK+7OZQWxeQU8JE68vAJkcwCtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ6bmGesWJucWl
	eel6yfm5mxjBMfRMagfjygaLQ4wCHIxKPLwaJwJDhFgTy4orcw8xSnAwK4nwHtUJChHiTUms
	rEotyo8vKs1JLT7EaAq0fCKzlGhyPjC+80riDY1NzIwsjcwNLYyMzZXEeQ+0WgcKCaQnlqRm
	p6YWpBbB9DFxcEo1ME71/ebyWejD7XRNbgFmhXimaXfOKcQsK3nVcPJd9dFilpstkQurymWf
	5MUJb8s2To3btaea47drxhw+70WzFrHUCkolOpVkGFdbrv5ivtD5fLPrzs6tkw/NNDD/ZJD7
	07YuklHw7A3Ljw9uf5p+RLD88Mynqt2TBaVWifM6Vm1bEbj/xauLC5VYijMSDbWYi4oTAdIk
	W7m3AgAA
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

