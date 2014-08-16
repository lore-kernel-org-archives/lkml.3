Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaHPS7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 14:59:54 -0400
Received: from fr1.as29.net ([62.210.131.231]:51992 "EHLO
	toothrot.meleeweb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaHPS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 14:59:51 -0400
From: Bertrand Jacquin <beber@meleeweb.net>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Cc: Bertrand Jacquin <beber@meleeweb.net>, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCH 0/3] handle module compression at install
Date: Sat, 16 Aug 2014 20:50:13 +0200
Message-Id: <1408215016-1848-1-git-send-email-beber@meleeweb.net>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is patchset based on tag v3.17-rc1 that aims to handle kernel
modules compression while running make modules_install.

Details about this operation are present in patch 2/3.

Please Cc me, as I'm not subscribed to LKML.

Bertrand Jacquin (3):
  modinst: wrap long lines in order to enhance cmd_modules_install
  kbuild: handle module compression while running 'make
    modules_install'.
  modsign: lookup lines ending in .ko in .mod files

 Makefile                 | 15 +++++++++++++++
 init/Kconfig             | 43 +++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.modinst |  7 ++++++-
 scripts/Makefile.modsign |  2 +-
 4 files changed, 65 insertions(+), 2 deletions(-)

-- 
2.0.4

