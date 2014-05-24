Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaEXOGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 10:06:12 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:49467 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEXOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 10:06:10 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Sat, 24 May 2014 23:06:09 +0900
X-Google-Sender-Auth: 2S_Zb34mAjvMU0ETvALEBCLbm0k
Message-ID: <CAJ0PZbSpcT3A+z0axkkPZD06bX1SNcKszJuYMDWHrUDiApooGA@mail.gmail.com>
Subject: [GIT PULL] devfreq update for Linux 3.16
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: rafael.j.wysocki@intel.com
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rafael,

Here goes the pull request of devfreq for 3.16


Cheers,
MyungJoo

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git tags/for-3.16

for you to fetch changes up to cb7063f453e543b97285a10343cfc02983d792ad:

  PM / devfreq: remove checks for CONFIG_EXYNOS_ASV (2014-05-24 22:33:51 +0900)

- ----------------------------------------------------------------
Pull Request for Rafael.

Merge target is Linux 3.16

- - Clean up with modern macro in the core and drivers.
- - Fix incorrect error returns
- - Remove dead CONFIG check.
- - Fix resource leak in a driver.

- ----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (3):
      PM / devfreq: exynos4: introduce struct busfreq_ppmu_data
      PM / devfreq: exynos5: introduce struct busfreq_ppmu_data
      PM / devfreq: exynos: make more PPMU code common

Chanwoo Choi (11):
      PM / devfreq: exynos4: Fix bug of resource leak and code clean on probe()
      PM / devfreq: exynos4: Use SIMPLE_DEV_PM_OPS macro
      PM / devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
      PM / devfreq: exynos5: Use SIMPLE_DEV_PM_OPS macro
      PM / devfreq: exynos5: Add CONFIG_PM_OPP dependency to fix probe fail
      PM / devfreq: exynos4: use common PPMU code
      PM / devfreq: Fix devfreq_remove_device() to improve the sequence ...
      PM / devfreq: Add resource-managed function for devfreq device
      PM / devfreq: Add devm_devfreq_{register,unregister}_opp_notfierfunction
      PM / devfreq: exynos4: Use devm_devfreq_* function using device ...
      PM / devfreq: exynos5: Use devm_devfreq_* function using device ...

Paul Bolle (1):
      PM / devfreq: remove checks for CONFIG_EXYNOS_ASV

 drivers/devfreq/Kconfig              |   5 +-
 drivers/devfreq/devfreq.c            | 125 ++++++++++++++++++--
 drivers/devfreq/exynos/Makefile      |   2 +-
 drivers/devfreq/exynos/exynos4_bus.c | 219 ++++++++++-------------------------
 drivers/devfreq/exynos/exynos5_bus.c | 130 ++++++---------------
 drivers/devfreq/exynos/exynos_ppmu.c |  60 ++++++++++
 drivers/devfreq/exynos/exynos_ppmu.h |   8 ++
 include/linux/devfreq.h              |  35 +++++-
 8 files changed, 317 insertions(+), 267 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTgKWPAAoJEDv/jgS9xknFYlMP/0zIsdDGxtJA3NdxJGT/dA+d
z7sDIBSOCQCBQv8CSMCY6HgtejgbtpRX8coKaSYGjLP9sL43hHCRkJesQdYNo5vE
xuU0Zo80ERBZvXj9pXC76ojmvBMRmynYPnbMC7ZgzGEFA2kSf/SoEAwSu6y+5uiF
b5igBp22QNd73V5c+Vjr6pzDfSXDyGDv5Km8jDFPvx3YLNChY471VtK+KMikGwGp
FplzfNSCThMPertAxKuWRlZMS8v0YVyO9TN4KHNQuwdGotiQcYweeAFL+G183ZaC
8m+komdIP2oct0h19j8298cGPQSH/NpCXTwXSFMhn/QEU6W3WtaTF3crURjhTxja
EZiSOClumMnZPJt6di10vV6TOS0e4pWgfP2ZX9sNRBYLf5Vs/P46kB3mzAM1LSeV
D/93dkv5mAoZPTt/eruB/4jOeQDewAtOf/o3/vOjXUu4QwQ7JARGUEZ8RKJktVHs
R5q7nrEFOckyoSME131ePODy5EUgYv2kFGmaLqwulZaUN7ooslBZiaph7Fc0f1VB
2TEQKLtbkPIYiDqTHF8MAkIjwzhuul02NpEN7UccHfc4RIkoyhNnOrhwsi2ktAJw
ID7x2ofVKvevHp2qiLWlAHAryEJ+aTYNpiDRByZiUWFrt8LlLIZuCkdxWYGWcyOY
dkeARTmbHnqfdYAeuTNn
=ZUxh
-----END PGP SIGNATURE-----
