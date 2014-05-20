Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaETA17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:27:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58965 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaETA15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:27:57 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-98-537aa18b9c1a
Message-id: <537AA18A.9080900@samsung.com>
Date: Tue, 20 May 2014 09:27:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] extcon next for v3.16
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSoNu9sCrY4OxkTovmxevZLM42vWG3
	uLxrDpvF7cYVbA4sHvvnrmH36NuyitHj8ya5AOYoLpuU1JzMstQifbsEroxJLzQKHutXbFz5
	gbGB8bBaFyMnh4SAicS/ZStYIGwxiQv31rOB2EICSxklDq9Nh6nZ/WovcxcjF1B8EaPEjYal
	LBDOa0aJxe8PMINU8QpoSaw7dp8JxGYRUJU4e6wLbCobUHz/ixtgU0UFwiRWTr/CAlEvKPFj
	8j0wW0RAQ+Ll0VtgNrNAO6PEjzmMILawgKbE6WO/oeI6Evtbp7FB2PISm9e8BbtIQqCdXeLO
	t7fMEIsFJL5NPgTUwAGUkJXYBHGbhICkxMEVN1gmMIrMQrJ6FpKxs5CMXcDIvIpRNLUguaA4
	Kb3ISK84Mbe4NC9dLzk/dxMjMCZO/3vWt4Px5gHrQ4zJQCsnMkuJJucDYyqvJN7Q2MzIwtTE
	1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDOl935+/nPeYcvzcoT
	2Xip6ahYvCufQ/7vVxL5M4LqRXx1RX1Cv/wLXuFhuDpY860Xu6Qcw8WN0wxuRs86JVA/Zceq
	n/06DRPdvOpPrjHX/s6d0Tlf/O7Fvv8O35qY7V5fW9mQNOO0n01y/S01tba4x38DOE1bfZNY
	2bv8WaufdLy0eb/+4QUlluKMREMt5qLiRAAgU9vqnwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd3uhVXBBs37mCyaF69nszjb9Ibd
	4vKuOWwWtxtXsDmweOyfu4bdo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJaxgzJr3QKHisX7Fx5QfGBsbDal2MnBwSAiYSu1/tZYawxSQu3FvP1sXIxSEk
	sIhR4kbDUhYI5zWjxOL3B8CqeAW0JNYdu88EYrMIqEqcPdbFAmKzAcX3v7jBBmKLCoRJrJx+
	hQWiXlDix+R7YLaIgIbEy6O3wGxmgXZGiR9zGEFsYQFNidPHfkPFdST2t05jg7DlJTavecs8
	gZFvFpJRs5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcMw9k97BuKrB4hCj
	AAejEg/vAfGqYCHWxLLiytxDjBIczEoivDtTgUK8KYmVValF+fFFpTmpxYcYk4E+ncgsJZqc
	D0wHeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGMCXUPws
	5byd1/5FzXE5D87a5636xbp0lkj+5eU+Abv+zPs2s3P1nKSQez1fAoos5j0/8f7lcu+U3A0T
	l2Z/seJ2Wfmw5uirh3tvLVY8IPHSRyBwvXFj83QZjuc/Ajl0vrbV/mWdpnadqyFfKuLa7/v3
	oyX7+Li05zoU9lustuG3y06s+9ifrMRSnJFoqMVcVJwIAG4tucz9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next full request for v3.16. I add detailed description of this
pull request on below. Please pull extcon with following updates.

I report you about merge of MAX77836 patchset from MFD git repo(Lee Jones).
The MAX77836 patchset in this pull request has the dependency on various
subsystem(MFD/Regulator/Extcon). To protect merge conflit, firstly MFD Maintainer
created Immutable branch(branch: ib-mfd-extcon-3.16) and then I merged it on
extcon-next branch.

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.16

for you to fetch changes up to 3f79a3fb5f41e8f2229e5bf8aa725eaa79686f14:

  extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev (2014-04-29 09:52:12 +0900)

----------------------------------------------------------------
Update extcon for v3.16

This patchset add resource-managed functions to automatically control the memory
and unregistration operation of extcon. Also, This series support new MAX77836
extcon device driver on existing MAX14577 device because existed a little
difference between MAX77836 and MAX14577. Finally, Fix minor issue of extcon
driver.

Detailed description for patchset:
1. Add resource-managed functions
- Add resource-managed functions to automatically free the memory of extcon
structure and to control unregistration behavior as following. This new devm_*
functions applied all of extcon drivers in drivers/extcon/.
: devm_extcon_dev_register/unregister()
: devm_extcon_dev_allocate/free()
: extcon_dev_allocate/free() for devm_extcon_dev_allocate/free()

2. Add new MAX77836 extcon device
- Support MAX77836 device on existing MAX14577 device driver using
different compatible string. This patchset has dependency on MFD/
Regulator/Extcon. So, Lee Jones(MFD Maintainer) created Immutable
branch between MFD and Extcon due for v3.16 merge-window and then
I merged this patchset from MFD git repo[1] to Extcon git repo.
: [1] git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
  (branch: ib-mfd-extcon-3.16)

3. Fix minor issue of extcon driver
- extcon-palmas driver
: Fix issue of extcon device name for probe
- extcon-max14577
: Fix probe failure about handling wrong return value.
: Properly Handle return value of regmap_irq_get_virq function.
- extcon-max8997/max77693 driver
: Fix NULL pointer exception on missing pdata

4. Code clean for extcon driver
- extcon-max8997/max77693
: Use power efficient workqueue for delayed cable detection

----------------------------------------------------------------
Chanwoo Choi (11):
      extcon: max14577: Change extcon name instead of static name according to device type
      Merge tag 'ib-mfd-extcon-3.16' of git://git.kernel.org/.../lee/mfd into HEAD
      extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
      extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
      extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
      extcon: max77693: Use devm_extcon_dev_allocate for extcon_dev
      extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
      extcon: arizona: Use devm_extcon_dev_allocate for extcon_dev
      extcon: adc-jack: Use devm_extcon_dev_allocate for extcon_dev
      extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
      extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev

Kishon Vijay Abraham I (1):
      extcon: palmas: explicitly set edev name as node name

Krzysztof Kozlowski (14):
      mfd: max14577: Add muic prefix to regmap config
      mfd: max14577: Add detection of device type
      extcon: max14577: Add max14577 prefix to muic_irqs
      extcon: max14577: Choose muic_irqs according to device type
      mfd: max14577: Add MAX14577 prefix to IRQ defines
      mfd: max77836: Add MAX77836 support to max14577 driver
      extcon: max14577: Add support for MAX77836
      regulator: max14577: Add support for MAX77836 regulators
      extcon: max77693: Fix two NULL pointer exceptions on missing pdata
      extcon: max8997: Fix NULL pointer exception on missing pdata
      extcon: max77693: Use power efficient workqueue for delayed cable detection
      extcon: max8997: Use power efficient workqueue for delayed cable detection
      extcon: max14577: Fix probe failure on successful work queue
      extcon: max14577: Properly handle regmap_irq_get_virq error

Sangjung Woo (8):
      extcon: Add resource-managed extcon register function
      extcon: adc-jack: Use devm_extcon_dev_register()
      extcon: gpio: Use devm_extcon_dev_register()
      extcon: max14577: Use devm_extcon_dev_register()
      extcon: max77693: Use devm_extcon_dev_register()
      extcon: max8997: Use devm_extcon_dev_register()
      extcon: palmas: Use devm_extcon_dev_register()
      extcon: arizona: Use devm_extcon_dev_register()

 drivers/extcon/Kconfig               |   4 +-
 drivers/extcon/extcon-adc-jack.c     |  49 +++---
 drivers/extcon/extcon-arizona.c      |  40 ++---
 drivers/extcon/extcon-class.c        | 151 +++++++++++++++++
 drivers/extcon/extcon-gpio.c         |  37 ++--
 drivers/extcon/extcon-max14577.c     | 199 +++++++++++++++-------
 drivers/extcon/extcon-max77693.c     |  23 ++-
 drivers/extcon/extcon-max8997.c      |  16 +-
 drivers/extcon/extcon-palmas.c       |  41 +++--
 drivers/mfd/Kconfig                  |   6 +-
 drivers/mfd/max14577.c               | 315 ++++++++++++++++++++++++++++++-----
 drivers/regulator/Kconfig            |   7 +-
 drivers/regulator/max14577.c         | 277 ++++++++++++++++++++++++++----
 include/linux/extcon.h               |  37 ++++
 include/linux/mfd/max14577-private.h | 222 ++++++++++++++++++------
 include/linux/mfd/max14577.h         |  19 ++-
 include/linux/mfd/palmas.h           |   2 +-
 17 files changed, 1131 insertions(+), 314 deletions(-)
