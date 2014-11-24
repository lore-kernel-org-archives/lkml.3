Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaKXMIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:08:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30267 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaKXMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:08:37 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d6-54731fc3e270
Message-id: <54731FC3.30809@samsung.com>
Date: Mon, 24 Nov 2014 21:08:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        =?UTF-8?B?7J6E6re87Iud?= <geunsik.lim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon next for 3.19
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkRPewfHGIwd4VohbXvzxntfgzoZXN
	onnxejaLs01v2C0u75rDZnG7cQWbA5vH/rlr2D36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr
	o2f3BbaCabwVkz6eYGxg/M/VxcjJISFgInFkeRcjhC0mceHeerYuRi4OIYGljBLLbnUwwxTt
	X/GHESKxiFGi/fVlZgjnNaPEwvOLwap4BTQkJhx6xwRiswioSvw+cZsFxGYT0JLY/+IGG4gt
	KhAmsXL6FRaIekGJH5PvgdkiQL0vj95iARnKLPCRUWLnsX1ADRwcwkCJxweVQGqYBdQlJs1b
	xAxhy0tsXvMW6rpF7BLTJglC7BWQ+Db5EAtIq4SArMSmA1AlkhIHV9xgmcAoMgvJ5llIps5C
	MnUBI/MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMBIOf3vWd8OxpsHrA8xCnAwKvHwfthY
	FCLEmlhWXJl7iNEU6IqJzFKiyfnAeMwriTc0NjOyMDUxNTYytzRTEudNkPoZLCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoGR2yJoooDHl7btgv2vrhbHrZE4H5ygeOr8vHfCXKGRWd/Eemy0
	fnT/C/a7Vi4ku++1e/jRE2ce7HOS38SfKZFuL/Cl5pP1R7WrWsvmXOBbwuKUsPgkW8GWB7fa
	MvtZ9sZWm214eslu92SfPXeKhCd0bF/6v/r9KgarDfMOvQwNYKmtVuzp4JyixFKckWioxVxU
	nAgA3wvpXY8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd3D8sUhBvdX8lpc//Kc1eLPhFY2
	i+bF69kszja9Ybe4vGsOm8XtxhVsDmwe++euYffo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxoye3RfYCqbxVkz6eIKxgfE/VxcjJ4eEgInE/hV/GCFs
	MYkL99azdTFycQgJLGKUaH99mRnCec0osfD8YmaQKl4BDYkJh94xgdgsAqoSv0/cZgGx2QS0
	JPa/uMEGYosKhEmsnH6FBaJeUOLH5HtgtghQ78ujt1hAhjILfGSU2HlsH1ADB4cwUOLxQSWQ
	GmYBdYlJ8xYxQ9jyEpvXvGWewMg3C8moWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOBKfSe1gXNlgcYhRgINRiYf3w8aiECHWxLLiytxDjBIczEoivGJixSFCvCmJlVWp
	RfnxRaU5qcWHGE2BPp3ILCWanA9MEnkl8YbGJmZGlkbmhhZGxuZK4rw3buaGCAmkJ5akZqem
	FqQWwfQxcXBKNTAq1Cp9mL36fn3vm8Qg1nka00sK2Rbe/VYS3uzeyhcxJy3GLXdC3IczBX4R
	/lJ6X4L+R73ic9oyh2Pz9V97H8SmWlzeyHFTbJfGJPu3PSGy2/JqP6/rm5WkWnV08nb9JS5L
	H8zSmWT//btR9N0rX4Jfb4soVzFJbMnckXjFNmPfbnHjgGK/V/eUWIozEg21mIuKEwEMW4BF
	2gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next full request for v3.19. I add detailed description of this
pull request on below. Please pull extcon with following updates.

This pull-request is based on Linux 3.18-rc3 (char-misc-next branch).

Best Regards,
Chanwoo Choi

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.19

for you to fetch changes up to 6ab0b1171b068a1be871184fc704074ad7e5b9e7:

  extcon: max14577: Fix obvious typo in company name in copyright (2014-11-24 20:51:15 +0900)

----------------------------------------------------------------
Update extcon for v3.19

This patchset fix minor issue of extcon driver.

Detailed description for patchset:
- Fix typo and change jig cable name of extcon-max77693.c
- Update the extcon_get_edev_by_phandle() because previous extcon_get_edev_by_phandle()
  considered only the platform device driver. So, this modification supports
  OF-based extcon lookup method by using the list of extcon devices.

----------------------------------------------------------------
Krzysztof Kozlowski (2):
      extcon: max77693: Fix cable name of JIG_UART_ON
      extcon: max14577: Fix obvious typo in company name in copyright

Tomasz Figa (1):
      extcon: Implement OF-based extcon lookup properly

 drivers/extcon/extcon-class.c    | 14 +++++++++-----
 drivers/extcon/extcon-max14577.c |  2 +-
 drivers/extcon/extcon-max77693.c | 12 +++++++-----
 3 files changed, 17 insertions(+), 11 deletions(-)
