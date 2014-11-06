Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKFMwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:52:10 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:42736 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKFMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:52:07 -0500
MIME-Version: 1.0
Date: Thu, 6 Nov 2014 13:52:06 +0100
Message-ID: <CAPDyKFqmCaabAxS=KF8=9ZfinBtVpkb8=SNhXhY5gPtv1xOrQw@mail.gmail.com>
Subject: [GIT PULL] MMC fixes for v.3.18
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is one mmc fix for 3.18.

MMC core:
- Fix card detection regression.
The MMC_CAP2_CD_ACTIVE_HIGH and MMC_CAP2_RO_ACTIVE_HIGH could under
some circumstances be set incorrectly, causing the card detection to
fail.

Information also collected in the signed tag. Please pull this in!

Kind regards
Ulf Hansson


The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.18-2

for you to fetch changes up to a31b0c6c19bf28c54999c3cd8cc3a7c8ba565a45:

  mmc: core: fix card detection regression (2014-11-05 09:28:48 +0100)

----------------------------------------------------------------
MMC core:
 - Fix card detection regression.
   The MMC_CAP2_CD_ACTIVE_HIGH and MMC_CAP2_RO_ACTIVE_HIGH could under
   some circumstances be set incorrectly, causing the card detection to
   fail.

----------------------------------------------------------------
Kristina Martsenko (1):
      mmc: core: fix card detection regression

 drivers/mmc/core/host.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)
