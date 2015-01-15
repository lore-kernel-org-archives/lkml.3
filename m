Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbbAOI6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:58:13 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:34869 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbbAOI6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:58:11 -0500
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 09:58:10 +0100
Message-ID: <CAPDyKFqXCwZN6G+fGDcEkufpDrcgBXJfsmRDCxT5Jp6RpgmSNw@mail.gmail.com>
Subject: [GIT PULL] MMC fixes for v.3.19, take 3
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is one more mmc fix for 3.19, take 3. I expect this to be the
last fix for mmc for 3.19.

Do note that it's based on your master branch from yesterday and not
on an rc which is what I do normally. If you don't like it like this,
I can re-base it next week.

Details are as usual found in the signed tag.

Kind regards
Ulf Hansson


The following changes since commit 188c901941efd43cbf21e8f4f9e9a276536b989c:

  Merge branch 'leds-fixes-for-3.19' of
git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds
(2015-01-14 12:22:56 +1300)

are available in the git repository at:


  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.19-4

for you to fetch changes up to 3cbc6123a93dc91b99b58f7ea37d267fe93e1cad:

  mmc: sdhci: Set SDHCI_POWER_ON with external vmmc (2015-01-14 09:47:19 +0100)

----------------------------------------------------------------
MMC host:
- sdhci: Fix regulator regression for Qualcomm and Nvidia boards

----------------------------------------------------------------
Tim Kryger (1):
      mmc: sdhci: Set SDHCI_POWER_ON with external vmmc

 drivers/mmc/host/sdhci.c | 6 ++++++
 1 file changed, 6 insertions(+)
