Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaIQCrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:47:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8817 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaIQCr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:47:29 -0400
X-AuditID: cbfee68f-f797f6d000001173-98-5418f63f1f61
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND 0/2] Update smb347 charger driver.
Date: Wed, 17 Sep 2014 11:47:22 +0900
Message-id: <1410922044-4170-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkWNf+m0SIwclfvBYHt2paTHryntli
	4srJzBadZ58wW1zeNYfN4nPvEUaLu6eOslmc3l3iwOExof8To8fOWXfZPTav0PLYtKqTzaNv
	yypGjxWrv7N7fN4kF8AexWWTkpqTWZZapG+XwJUxp3Evc8F1lornG1sYGxjvMHcxcnJICJhI
	3L9zlgXCFpO4cG89WxcjF4eQwFJGidP/H7LCFB1oms0IkVjEKLHo1Wsop41JYvLp12BVbAI6
	Ev/33WQHsUUEFCQ29z5jBSliFljMKPH01AuwfcIClhIP9iwB28cioCpxYt0usGZeAXeJr00H
	gWo4gNYpSMyZZAPSKyEwmV3iRtdCRoh6AYlvkw+xQNTISmw6APWCpMTBFTdYJjAKLmBkWMUo
	mlqQXFCclF5krFecmFtcmpeul5yfu4kRGNCn/z3r38F494D1IUYBDkYlHt4NlyVChFgTy4or
	cw8xmgJtmMgsJZqcD4ybvJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OFBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MK6+vzWxid0ofV2YSKdca/3i2KnRrWUiS4O3nqt6G692RWXXh46EO+br5GbZ
	9d8PP6u4S3ZLNJdgivupdwWLq665xWiGbI7l9Jupffu758Yy7sypPznaHkzjbbMpffbvavsn
	vac7Hsrl6zQKvhW94H24rf5wy7djL4T2cWe/7xX+Zzb3rn9FsRJLcUaioRZzUXEiAAs+iclj	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAV37bxIhBv+XsFsc3KppMenJe2aL
	iSsnM1t0nn3CbHF51xw2i8+9Rxgt7p46ymZxeneJA4fHhP5PjB47Z91l99i8Qstj06pONo++
	LasYPVas/s7u8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjDmN
	e5kLrrNUPN/YwtjAeIe5i5GTQ0LAROJA02xGCFtM4sK99WxdjFwcQgKLGCUWvXrNCOG0MUlM
	Pv2aFaSKTUBH4v++m+wgtoiAgsTm3mesIEXMAosZJZ6eegE2VljAUuLBniUsIDaLgKrEiXW7
	wJp5BdwlvjYdBKrhAFqnIDFnks0ERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj
	5Zn0DsZVDRaHGAU4GJV4eDdclggRYk0sK67MPcQowcGsJMIrcg8oxJuSWFmVWpQfX1Sak1p8
	iNEUaPlEZinR5HxgLOeVxBsam5gZWRqZG1oYGZsrifMebLUOFBJITyxJzU5NLUgtgulj4uCU
	amCcmrHd8dMcc+GTZRPO7K558cJlb6aZ79nM5wm3jfhFlE7Gn5Jaq6NdwyNwR1wpPW97fGL3
	xhM3M48r75Iq0/6ebd+S5ZC5dqVl/Z5k4Vs1C0+3Kv38/XGN5aJCn8JD4pY22jLRfzlW6J4I
	rt+wW/9sfslXgRenEuV2XVhWWdsSleA+6Uzb7r1KLMUZiYZazEXFiQDQsImjrQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set updates smb347 driver to support dt-binding and smb358 chip.

Jonghwa Lee (2):
  power: smb347-charger: Support devicetree binding for smb347 driver.
  power: smb347-charger: Support Summit SMB358 charger IC.

 .../bindings/power_supply/smb347_charger.txt       |   58 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/smb347-charger.c                     |  242 +++++++++++++-------
 3 files changed, 214 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/smb347_charger.txt

-- 
1.7.9.5

