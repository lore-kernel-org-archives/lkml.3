Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3GJGHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:07:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19237 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3GJGHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:07:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Jul 2013 23:08:27 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] extcon: palmas: clean-up/fixes and suspend/resume susupport
Date: Wed, 10 Jul 2013 11:45:55 +0530
Message-ID: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series does following:
- Remove unused member from extcon palmas structure.
- Fix to support of detecting cable properly with multiple insert/removal.
- Add support for suspend/resume functionlaity and wakup from suspend.
- Option to select/de-select the ID or VBUS detection.

Changes from V1:
- Correct the display message.
- Add ack from Graeme

Laxman Dewangan (4):
  extcon: palmas: remove unused member from palams_usb structure
  extcon: palmas: enable ID_GND and ID_FLOAT detection always
  extcon: palams: add support for suspend/resume
  extcon: palmas: Option to disable ID/VBUS detection based on platform

 .../devicetree/bindings/extcon/extcon-palmas.txt   |    2 +
 drivers/extcon/extcon-palmas.c                     |  111 ++++++++++++++------
 include/linux/mfd/palmas.h                         |    9 +-
 3 files changed, 86 insertions(+), 36 deletions(-)

