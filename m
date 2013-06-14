Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3FNMjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:39:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14774 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FNMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:39:15 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-20-51bb0ef1d436
Message-id: <51BB0EF1.5090203@samsung.com>
Date: Fri, 14 Jun 2013 21:39:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon for 3.11
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkRPcj3+5Ag+YHRhbXvzxntWhevJ7N
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyljT/pyt
	4LBExcXNn1kaGDuEuxg5OSQETCQO/nrHAmGLSVy4t56ti5GLQ0hgKaPEnzuPWWGKOvdeYoRI
	LGKUePzxFguE84JR4siX7WBVvAJaEr/aL4CNYhFQlXi24jkTiM0GFN//4gYbiC0qECaxcvoV
	Foh6QYkfk++B2SICGhIvj94Cs5kF5jBK7P7HCGILCyhLdH+ZxQYR15HY3zoNypaX2LzmLTPE
	dZPZJc79CYfYKyDxbfIhoDkcQHFZiU0HoEokJQ6uuMEygVFkFpLNs5BMnYVk6gJG5lWMoqkF
	yQXFSelFhnrFibnFpXnpesn5uZsYgfFx+t+z3h2Mtw9YH2JMBlo5kVlKNDkfGF95JfGGxmZG
	FqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDscVhXbnq7guH1
	kpKwnbkyz/+Vn3zzddOynYLC97POd73lPuL0oNaQq/3yl9/1nTIONRumliQJHmo4padrkrNk
	J6eD50V1zobI8Blbn9/Vk9eWb/0ptMLlv5NbofLHmzv83bbzxEsxOjw8LW4r+qlL+JzY0sh3
	6zhfq22ccPK2ZsIDET4+j59KLMUZiYZazEXFiQApo10RpQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAd2PfLsDDc6s1ba4/uU5q0Xz4vVs
	Fmeb3rBbXN41h83iduMKNgdWj/1z17B79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPGmvbnbAWHJSoubv7M0sDYIdzFyMkhIWAi0bn3EiOELSZx4d56
	ti5GLg4hgUWMEo8/3mKBcF4wShz5sp0VpIpXQEviV/sFFhCbRUBV4tmK50wgNhtQfP+LG2wg
	tqhAmMTK6VdYIOoFJX5MvgdmiwhoSLw8egvMZhaYwyix+x/YZmEBZYnuL7PYIOI6Evtbp0HZ
	8hKb17xlnsDINwvJqFlIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzj+nknv
	YFzVYHGIUYCDUYmHN+HCzkAh1sSy4srcQ4wSHMxKIry/WHYHCvGmJFZWpRblxxeV5qQWH2JM
	Bvp0IrOUaHI+MDXklcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwen
	VAPj1KMP33/89FRTzPLMObeGb8w9itduKZnle5x+aNIeIRdnJ//LJMRU9TO31xrrtVUFYfc8
	LocfN3BtFbmjX1bZ8LPxw/tTHuyqbWL2ypVvn1mrHD03dfkZn5Ii164mP/cZWqv3bOfg0mKy
	mbj9HU/SUjaBjf5dTuej08oEWw8vDWM0tTkk1avEUpyRaKjFXFScCABeS3+ZAwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

First of all, I'm so sorry about previous wrong pull-request.
I will be careful and not to make same mistakes

This is extcon-next pull request for 3.11
Please pull extcon with following updates.

I combined the patch of small fix and new drivers becasue
3.10-rc version is large.

Best Regards,
Chanwoo Choi

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.11

for you to fetch changes up to f7ae906806279e5b57bfd302b945e1bcdddce95b:

  extcon: Add an API to get extcon device from dt node (2013-06-14 18:36:34 +0900)

----------------------------------------------------------------
Update extcon for 3.11

This patchset modify small fix of extcon core driver and add new extcon
driver for Palmas device which is USB tranceiver device. Also, support
OF helper API to get the name of extcon device(producer driver) on extcon
consumer driver.

Detailed description for patchset:
1. Modify extcon-class driver
- Change permission 'state' sysfs entry(rw->r)
- Use EXPORT_SYMBOL_GPL for exported functions
- Fix bug null pointer when call extcon_unregister_interest

2. Modify Kconfig of extcon
- Change the extcon config type to bool from module. If extcon
is built as module and then extcon consumer driver uses API of,
extcon, compiler happen "undefined reference to" build error.

3. Add new extcon driver for Palmas device and OF helper API
- Add new extcon drvier for Palmas which is USB tranceiver device
- Add OF(Open Firmware) Helper API which is of_extcon_get_extcon_dev()
  This helper API get the extcon device name on extcon consumer device.

----------------------------------------------------------------
Chanwoo Choi (1):
      extcon: Change permission 'state' sysfs entry (rw -> r)

Graeme Gregory (1):
      extcon: Palmas Extcon Driver

Jonghwa Lee (1):
      extcon: class: Add NULL pointer checking for removing notifier block.

Kishon Vijay Abraham I (3):
      extcon: Kconfig: Make extcon config type as bool
      extcon: add EXPORT_SYMBOL_GPL for exported functions
      extcon: Add an API to get extcon device from dt node

 .../devicetree/bindings/extcon/extcon-twl.txt      |  15 ++
 drivers/extcon/Kconfig                             |   9 +-
 drivers/extcon/Makefile                            |   3 +
 drivers/extcon/extcon-class.c                      |  30 +--
 drivers/extcon/extcon-palmas.c                     | 246 +++++++++++++++++++++
 drivers/extcon/of_extcon.c                         |  64 ++++++
 include/linux/extcon/of_extcon.h                   |  32 +++
 include/linux/mfd/palmas.h                         |  26 ++-
 8 files changed, 388 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-twl.txt
 create mode 100644 drivers/extcon/extcon-palmas.c
 create mode 100644 drivers/extcon/of_extcon.c
 create mode 100644 include/linux/extcon/of_extcon.h
