Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab3CMX0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:26:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42955 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441Ab3CMX0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:26:32 -0400
X-AuditID: cbfee68d-b7f786d000005188-0a-51410b25fc96
Message-id: <51410B25.907@samsung.com>
Date: Thu, 14 Mar 2013 08:26:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon fixes for 3.9-rc3
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t8zbV1VbsdAg5mf+S2uf3nOatG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFx23am
	giaeio8vDBsYH3N2MXJySAiYSFxa+ZoRwhaTuHBvPVsXIxeHkMAyRokjW1pYYIo23/7GBJGY
	zihx6moflPOCUaLn4gZmkCpeATWJfXefgnWwCKhK7L/3mBXEZhPQktj/4gYbiC0qECaxcvoV
	Foh6QYkfk++B2SICGhIvj94Cs5kFVjFKPD0h08XIwSEsoCPxcJYqRNhM4lHLOmYIW15i85q3
	zCA3SAhMZ5fYemY7M8ReAYlvkw+xgPRKCMhKbDrADPGApMTBFTdYJjCKzEKyeRaSsbOQjF3A
	yLyKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIyQ6encw3j5gfYgxGWjlRGYp0eR8YHTllcQb
	GpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxs2qB1L7g
	Q4k2T2SKnsc9PB/yfEa9CpvwiYky0Q5CzPtVM8u41kn8u679XnDG3ISQ0r5DK9hm/b3aolFo
	yxL6VmJP8S775Lrp5Ye2eUw6Nn/CDbWMXZ++WFje8d9q26NXtvmr8tsXUgaMivXMtieXxO/i
	/efT65Lk4jTxdL2wLN8Svdlnt2kqsRRnJBpqMRcVJwIAYVv+U6QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jQV1VbsdAg+vruSyuf3nOatG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYx5hxcdt2poImnoqPLwwbGB9zdjFyckgImEhsvv2NCcIWk7hwbz1b
	FyMXh5DAdEaJU1f7mCCcF4wSPRc3MINU8QqoSey7+5QFxGYRUJXYf+8xK4jNJqAlsf/FDTYQ
	W1QgTGLl9CssEPWCEj8m3wOzRQQ0JF4evQVmMwusYpR4ekKmi5GDQ1hAR+LhLFWIsJnEo5Z1
	zBC2vMTmNW+ZJzDyzUIyaRaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI69
	Z9I7GFc1WBxiFOBgVOLhlZjkECjEmlhWXJl7iFGCg1lJhDeExTFQiDclsbIqtSg/vqg0J7X4
	EGMy0KMTmaVEk/OBaSGvJN7Q2MTMyNLIzNjE3NiYNGElcd6DrdaBQgLpiSWp2ampBalFMFuY
	ODilGhgLrutu8eSSkq2L2Pf8eulvk/s7RKVaXn/14OtJDc66e5txx6IvSy5stdo+lc3omsyS
	b9fEFc8bfmx9wj67p2C++h5Jnq1MMVUvrNZGZfkYvzk2u/1+84YW/i4eTokr9mYbW/9/PZuj
	ZLGksSRcs+P51W+P7uh+sUnUux7M+jzR9fjmnqMSnt1KLMUZiYZazEXFiQD/xACdAQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon fixes for 3.9-rc3.
Please pull extcon with following updates.

Best Regards,
Chanwoo Choi

The following changes since commit 
f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git 
tags/extcon-3.9-rc3

for you to fetch changes up to 0ec83bd2460ed6aed0e7f29f9e0633b054621c02:

   extcon: max77693: Initialize register of MUIC device to bring up it 
without platform data (2013-03-13 17:38:57 +0900)

----------------------------------------------------------------
extcon fixes for 3.9-rc3

This is small fixes against 3.9-rc2.

Fix to max77693 extcon driver:
- Set default value of MUIC register to bring up it.
Fix to max8997 extcon driver:
- Fix null pointer error duing probe when platform data
isn't used.

----------------------------------------------------------------
Chanwoo Choi (3):
       extcon: max8997: Check the pointer of platform data to protect 
null pointer error
       extcon: max77693: Fix bug of wrong pointer when platform data is 
not used
       extcon: max77693: Initialize register of MUIC device to bring up 
it without platform data

  drivers/extcon/extcon-max77693.c     | 103 
+++++++++++++++++++++++++++--------
  drivers/extcon/extcon-max8997.c      |  56 +++++++++++--------
  include/linux/mfd/max77693-private.h |  23 ++++++++
  3 files changed, 137 insertions(+), 45 deletions(-)
