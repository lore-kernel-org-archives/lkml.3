Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbaCSHxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:53:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61349 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbaCSHxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:53:16 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-2e-53294ce8af38
Message-id: <53294CE9.8030301@samsung.com>
Date: Wed, 19 Mar 2014 16:53:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] extcon next for 3.15
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSoPvSRzPY4PB2JovmxevZLM42vWG3
	uLxrDpvF7cYVbA4sHvvnrmH36NuyitHj8ya5AOYoLpuU1JzMstQifbsEroxbnwIL1gpWnJrw
	iLmBcT5fFyMnh4SAicTUOR2sELaYxIV769m6GLk4hASWMkps/dTIDFN08VojO0RiEaPEtmf3
	WSCcV4wSC05tAWvnFdCS2H38NJDNwcEioCpx84MkSJgNKLz/xQ02EFtUIExi5fQrLBDlghI/
	Jt8Ds0UENCReHr0FZjMLtDNK/JjDCGILA8Xv77rGDhHXkdjfOo0NwpaX2LzmLTPIDRIC7ewS
	t04cAEuwCAhIfJt8iAXkBgkBWYlNB6AekJQ4uOIGywRGkVlIVs9CMnYWkrELGJlXMYqmFiQX
	FCelFxnqFSfmFpfmpesl5+duYgTGxOl/z3p3MN4+YH2IMRlo5URmKdHkfGBM5ZXEGxqbGVmY
	mpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo3hD14m/xw2L7euO
	10rzB+hvu1SQ9ul2S+mESV5vDa6tuqwlrJy7+F7HwiLBWUwCy21yG+aunM5sfSD06NZdre4r
	ivoXyqoujGeIuHs1/qTRWkd7S8G4csO79etVrqy0f6jTyL5omquPc89Bu7vu7f7hmxvd702x
	3tDGMtH0715mDicerUOaSizFGYmGWsxFxYkAvqPQ/58CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jAd0XPprBBm/WWFg0L17PZnG26Q27
	xeVdc9gsbjeuYHNg8dg/dw27R9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBm3PoUWLBWsOLUhEfMDYzz+boYOTkkBEwkLl5rZIewxSQu3FvP1sXIxSEk
	sIhRYtuz+ywQzitGiQWntrCCVPEKaEnsPn4ayObgYBFQlbj5QRIkzAYU3v/iBhuILSoQJrFy
	+hUWiHJBiR+T74HZIgIaEi+P3gKzmQXaGSV+zGEEsYWB4vd3XWOHiOtI7G+dxgZhy0tsXvOW
	eQIj3ywko2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCIeya1g3Flg8Uh
	RgEORiUe3gNRGsFCrIllxZW5hxglOJiVRHiF7wKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0
	OR+YDPJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVGn2Civ
	aa8E+zmFuysr7oaf9ElMnbN8d4xy35HvvgutzziqXskXElXRNqp6o2Cu8CHw36Yda4MZeG/w
	hDUZu3zX5H8r7RO7pPSaTMrl4pK9cSVMlxuij9zWU8ud3KS3VN9iMe919nO/VnK+cGHxyTGW
	KdzJI3U107//6TKR9Y8v2wjKiW9qUWIpzkg01GIuKk4EAPDU8Wf8AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next full request for v3.15. I add detailed description of this
pull request on below. Please pull extcon with following updates.

This patchset is rebased on 'Linux 3-14-rc5' because char-misc-next is based on
'Linux 3-14-rc5'.

Best Regards,
Chanwoo Choi

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.15

for you to fetch changes up to 1ad94ffef22c0a6e2ee6ba90a800c32fd29ffa1f:

  extcon: Move OF helper function to extcon core and change function name (2014-03-19 14:41:58 +0900)

----------------------------------------------------------------
Update extcon for v3.15

This patchset fix minor issue.

The extcon-palmas/gpio use SIMPLE_DEV_PM_OPS macro instead of legacy method.
OF helper function of extcon move in extcon core to remove separate of_extcon.c
and change the name of OF helper function as following because previous function
name is complicated and ambiguous naming.
- of_extcon_get_extcon_dev() -> extcon_get_edev_by_phandle()

----------------------------------------------------------------
Chanwoo Choi (2):
      extcon: of: Remove unnecessary function call by using the name of device_node
      extcon: Move OF helper function to extcon core and change function name

Jingoo Han (2):
      extcon: palmas: Use SIMPLE_DEV_PM_OPS macro
      extcon: gpio: Use SIMPLE_DEV_PM_OPS macro

 drivers/extcon/Kconfig           |  4 ---
 drivers/extcon/Makefile          |  2 --
 drivers/extcon/extcon-class.c    | 42 ++++++++++++++++++++++++++
 drivers/extcon/extcon-gpio.c     |  4 +--
 drivers/extcon/extcon-palmas.c   |  5 +---
 drivers/extcon/of_extcon.c       | 64 ----------------------------------------
 drivers/usb/dwc3/dwc3-omap.c     |  3 +-
 include/linux/extcon.h           | 12 ++++++++
 include/linux/extcon/of_extcon.h | 31 -------------------
 9 files changed, 57 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/extcon/of_extcon.c
 delete mode 100644 include/linux/extcon/of_extcon.h
