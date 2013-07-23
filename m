Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab3GWXC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:02:57 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33486 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab3GWXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:02:56 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 24 Jul 2013 00:02:34 +0100
X-Google-Sender-Auth: -Ecy_k41XN_pydFCLC6I51QNgs0
Message-ID: <CACxGe6uW=6yh0xSS+WBWfqSwTzDQzjyb3heXArWs-yhB1n1fsw@mail.gmail.com>
Subject: [GIT PULL] devicetree and maintainers changes for v3.11-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following tag.

g.

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to cf9e2368655d86cd800e4d9fe65a407b39d29373:

  of/irq: init struct resource to 0 in of_irq_to_resource()
(2013-07-22 19:40:38 +0100)

----------------------------------------------------------------
Device tree bug fixes and maintainership updates for v3.11-rc2

This branch contains a couple of minor bug fixes and several changes to
the MAINTAINERS file regarding the subsystems I've been involved with.

----------------------------------------------------------------
Axel Lin (1):
      of/irq: Avoid calling list_first_entry() for empty list

Gabor Juhos (1):
      of: add vendor prefix for Qualcomm Atheros, Inc.

Grant Likely (4):
      MAINTAINERS: Remove Grant Likely
      MAINTAINERS: Change device tree mailing list
      MAINTAINERS: Refactor device tree maintainership
      MAINTAINERS: Fix incorrect status tag

Sebastian Andrzej Siewior (1):
      of/irq: init struct resource to 0 in of_irq_to_resource()

Zhangfei Gao (1):
      of: add vendor prefixes for hisilicon

 .../devicetree/bindings/vendor-prefixes.txt        |  2 ++
 MAINTAINERS                                        | 30 +++++++++++++---------
 drivers/of/irq.c                                   |  6 +++--
 3 files changed, 24 insertions(+), 14 deletions(-)
