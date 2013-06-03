Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3FCFZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:25:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31304 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3FCFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:25:47 -0400
X-AuditID: cbfee68f-b7f436d000000f81-24-51ac28da2cf4
Message-id: <51AC28DA.7050107@samsung.com>
Date: Mon, 03 Jun 2013 14:25:46 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon-next for 3.10
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkWPeWxppAgzX9GhbXvzxntWhevJ7N
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymjc0spW
	sIa3Yn7PS/YGxg1cXYycHBICJhIb3h9kg7DFJC7cWw9kc3EICSxllNg1r4sJpmjXg4ssEInp
	jBILNj6AqnrBKDFhXy9jFyMHB6+AlkTzM3mQBhYBVYnbF+ayg9hsQOH9L26AbRAVCJNYOf0K
	C4jNKyAo8WPyPTBbREBD4uXRW2A2s8AcRond/xhBbGGg+Ndz/5kh4joS+1unsUHY8hKb17xl
	BrlBQmAyu8TVtofMEIsFJL5NPsQCco+EgKzEpgPMEA9IShxccYNlAqPILCSrZyEZOwvJ2AWM
	zKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAuPj9L9n/TsY7x6wPsSYDLRyIrOUaHI+ML7y
	SuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC477eF
	2sVoUaG/B38r7HJJMZC1ab2W9KNkUdW77++vMjrY39UL7WmUOXz+mJJRqekRNi91l2auVZqV
	hbcMbG/zJekenXxF6IX0+yWmXltjp6/VX+Mw+2Pzzbfn9kbyhigw7Kq5+NJWr6ctV/7JqsjW
	gkv3+iJC/DKc+YU477feidn0MI9/bYYSS3FGoqEWc1FxIgCv6thWpQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd1bGmsCDaZvV7S4/uU5q0Xz4vVs
	Fmeb3rBbXN41h83iduMKNgdWj/1z17B79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWNG45ZWtoI1vBXze16yNzBu4Opi5OSQEDCR2PXgIguELSZx4d56
	ti5GLg4hgemMEgs2PoByXjBKTNjXy9jFyMHBK6Al0fxMHqSBRUBV4vaFuewgNhtQeP+LG2wg
	tqhAmMTK6VfAhvIKCEr8mHwPzBYR0JB4efQWmM0sMIdRYvc/RhBbGCj+9dx/Zoi4jsT+1mls
	ELa8xOY1b5knMPLNQjJqFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjr5n
	0jsYVzVYHGIU4GBU4uFlyFkdKMSaWFZcmXuIUYKDWUmEN3klUIg3JbGyKrUoP76oNCe1+BBj
	MtCnE5mlRJPzgYkhryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4
	pRoYxSM8ti0vjJ4389qyOwHBxbZmVfb5N09vkT8UaH/vaKDNR5a6PbobuGQW21ruK9lvMku6
	9LCaxNVGv6UzF2x9lmnzUtnn9o/3XivUo/rkZAqv37zAVxn6ic3aJPLZdrVnjDdDnR6UBO7c
	pidqqPDn2+LV/k0R5dejHmbOmvbxsnbOSTvWom1LlViKMxINtZiLihMBR86qgwIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon-next pull request for 3.10.
Please pull extcon with following updates.

Best regards and Thanks,
Chanwoo Choi

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git extcon-next-for-3.10

for you to fetch changes up to ce636025d872947bff154682c610cedd551b1d1e:

  extcon: Palmas Extcon Driver (2013-05-28 11:41:44 +0900)

----------------------------------------------------------------
extcon: updates for v3.10

This patchset two patchs as following:

New extcon drvier for Palmas device
- Add new extcon driver for Palmas which is USB tranceiver device
Modify performission /sys/class/extcon/[device name]/'state' sysfs entry
- Modify permission of sysfs entry from read/write to only read

----------------------------------------------------------------
Chanwoo Choi (1):
      extcon: Change permission 'state' sysfs entry (rw -> r)

Graeme Gregory (1):
      extcon: Palmas Extcon Driver

 .../devicetree/bindings/extcon/extcon-twl.txt      |  15 ++
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-class.c                      |  23 +-
 drivers/extcon/extcon-palmas.c                     | 246 +++++++++++++++++++++
 include/linux/mfd/palmas.h                         |  26 ++-
 6 files changed, 284 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-twl.txt
 create mode 100644 drivers/extcon/extcon-palmas.c
