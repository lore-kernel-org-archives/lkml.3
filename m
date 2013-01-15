Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3AOHeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:34:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44816 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3AOHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:34:11 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d1-50f5067141e6
Message-id: <50F5067A.2060104@samsung.com>
Date: Tue, 15 Jan 2013 16:34:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: [GIT PULL] extcon for 3.8-rc4
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+Znm4h29cAgzWrJCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGsg8HmQreS1bcaeFoYLwl0sXIySEhYCLRd38RE4QtJnHh3nq2
	LkYuDiGBZYwSG9/uY4cp+nhsChNEYhGjxMd5S6GcLiaJ55u2g7XzCmhJHNj3GMxmEVCVuPz5
	EVg3G1B8/4sbQGM5OEQFIiR+9XNAlAtK/Jh8jwXEFhHIlJjYsYUVZCazwDpGiVOPzoH1Cguo
	SWzYfwisiFlAR2J/6zQ2CFteYvOat8wQuwQkvk0GqeEAulRWYtMBZpA5EgKv2SS+b7/NCPGB
	pMTBFTdYJjCKzEKyexaSsbOQjF3AyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIyTEpXcw
	rmqwOMQowMGoxMN7U/dLgBBrYllxZe4hRgkOZiURXp93QCHelMTKqtSi/Pii0pzU4kOMPkDX
	TmSWEk3OB8ZfXkm8obGBsaGhpaGZqaWpAQ5hJXFexlNPAoQE0hNLUrNTUwtSi2DGMXFwSjUw
	RmUm/n+46pQG2+LY/6mMIsrz3349+lw7sD513kvh1QlyPkus56yJCV0bEmXMaHPCN0IwMevg
	tL3OFS+0ZX3E2ebXJr/ImMSR6dSy1aK6cEFXbJD9vVxdhqKor9s1p6nn+kT2nfktFtDC1qu6
	qL5b49yp/Yxhn3bXrkmy9c0QDIj5eNF4ZY8SS3FGoqEWc1FxIgA/YeKVngIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd1Ctq8BBuvOC1lc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGUfDjIVvJesuNPC0cB4
	S6SLkZNDQsBE4uOxKUwQtpjEhXvr2boYuTiEBBYxSnyct5QJwulikni+aTtYFa+AlsSBfY/B
	bBYBVYnLnx+xg9hsQPH9L24AdXNwiApESPzq54AoF5T4MfkeC4gtIpApMbFjCyvITGaBdYwS
	px6dA+sVFlCT2LD/EFgRs4COxP7WaWwQtrzE5jVvmScw8s1CMmsWkrJZSMoWMDKvYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAiOoGfSOxhXNVgcYhTgYFTi4b2p+yVAiDWxrLgy9xCjBAez
	kgivzzugEG9KYmVValF+fFFpTmrxIUYfoE8nMkuJJucDozuvJN7Q2MTMyNLIzNjE3NgYh7CS
	OC/jqScBQgLpiSWp2ampBalFMOOYODilGhiTXh0REzFkV5oU9FZp9hvRpfeO/Fao0GcRsBTl
	mnzgq1D9Ir4VU1hjPOXUKrf8ztO/O/nprcfzy/dMelmQsf6ArIthVfnyW76yJzim3LH5+dN6
	nuurhElNFhOz5H1/Gx7iUdiY5bv+tpi5jXprhI2KXOeEmXO/1nxT/KErV3Cf6UbMHqnPi5OU
	WIozEg21mIuKEwF6J/p8zQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is the extcon pull request for Linux 3.8-rc4.

Please pull extcon with following updates:

Update to max77693/max8997 extcon driver:
- Using MHL_TA cable for charging.
- Support JIG cable.
- Support Dock-Audio device for playing music and button of device.
- Support Dock-Smart device for desktop mode with mouse/keyboard.
- Set default UART/USB path on probe().
- Check the state/type of cable after completing initialization.
- Code clean to remove duplicate code and bug fix related to sequence of interrupt.
- Fix irq_flag of max8997/max77693 driver.

Update to arizona extcon driver:
- Headphone measurements.
- Alternative detection mechanism for non-default system designs.
- Microphone clamp integration.
- Support for additional detection pin.
- MICBIAS rise time configuration.

Thanks in advance for pulling,

Best regards,
Chanwoo Choi

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-3.8-rc4

for you to fetch changes up to 689557d3c7045320958d5bc4141088f7b4dff7ba:

  mfd: wm5102: Add microphone clamp control registers (2013-01-15 15:42:18 +0900)

----------------------------------------------------------------
Chanwoo Choi (9):
      extcon: max77693: Remove duplicate code by making function
      extcon: max77693: Add support MHL_TA cable for charging battery
      extcon: max77693: Add support jig cable
      extcon: max77693: Add support dock device and buttons
      extcon: max77693: Check the state/type of cable after boot completed
      extcon: max8997/max77693: Support IRQF_NO_SUSPEND flag for interrupt
      extcon: max77693: Set default uart/usb path by using platform data
      extcon: max77693: Fix bug when detecting MHL/Dock-Audio with USB/TA cable
      extcon: max77693: Add support Dock-Smart device for desktop mode

Mark Brown (11):
      extcon: arizona: Convert to devm_input_allocate_device()
      extcon: arizona: Remove duplicate mic ramp configuration
      extcon: arizona: Only set GPIO if it has been requested
      extcon: arizona: Allow configuration of MICBIAS rise time
      extcon: arizona: Use microphone clamp function if available
      extcon: arizona: Support use of GPIO5 as an input to jack detection
      extcon: arizona: Enable basic headphone identification
      extcon: Simple code motion supporting future work.
      extcon: arizona: Support HPDET based accessory identification
      extcon: arizona: Support direct microphone measurement via HPDET
      mfd: wm5102: Add microphone clamp control registers

 drivers/extcon/extcon-arizona.c       | 634 +++++++++++++++++++++--
 drivers/extcon/extcon-max77693.c      | 920 +++++++++++++++++++++++++---------
 drivers/extcon/extcon-max8997.c       |   6 +-
 drivers/mfd/wm5102-tables.c           |  10 +
 include/linux/mfd/arizona/core.h      |   4 +-
 include/linux/mfd/arizona/pdata.h     |  12 +
 include/linux/mfd/arizona/registers.h |  48 ++
 include/linux/mfd/max77693-private.h  |  86 ++++
 include/linux/mfd/max77693.h          |   9 +
 9 files changed, 1439 insertions(+), 290 deletions(-)
