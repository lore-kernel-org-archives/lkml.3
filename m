Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbbAMTAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:00:10 -0500
Received: from mga14.intel.com ([192.55.52.115]:22168 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbbAMTAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="669264087"
From: "Luck, Tony" <tony.luck@intel.com>
To: x86-ml <x86@kernel.org>
CC: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Borislav Petkov <bp@suse.de>
Subject: RE: [GIT PULL] RAS update for 3.20
Thread-Topic: [GIT PULL] RAS update for 3.20
Thread-Index: AQHQLymR3/WNX1uMmkyjEbKKjdqV2Zy+ZlXw
Date: Tue, 13 Jan 2015 19:00:06 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3299AD99@ORSMSX114.amr.corp.intel.com>
References: <20150113120713.GA5784@pd.tnic>
In-Reply-To: <20150113120713.GA5784@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0DJ0HZS030749

> Nothing special this time, just an error messages improvement from Andy
> and a cleanup from me.

Also this APEI change that hasn't seen much commentary since Tomas Nowicki pointed
out that v1 had cluttered up the APEI code with some x86-ism after he'd spent time
cleaning it up - so v2 addressed that by moving the x86 code out into arch/x86.

-Tony

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj-mmcfg

for you to fetch changes up to d91525eb8ee6a622ce476955fe1a2530ade87c83:

  ACPI, EINJ: Enhance error injection tolerance level (2014-12-15 11:36:37 -0800)

----------------------------------------------------------------
When checking addresses in APEI action entries for validity, allow
access the mmcfg space - some error injection functions need to do
this.

----------------------------------------------------------------
Chen, Gong (1):
      ACPI, EINJ: Enhance error injection tolerance level

 arch/x86/pci/mmconfig-shared.c | 28 ++++++++++++++++++++++++++++
 drivers/acpi/apei/apei-base.c  | 32 ++++++++++++++++++++++++++------
 2 files changed, 54 insertions(+), 6 deletions(-)


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
