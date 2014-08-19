Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaHSS5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:57:52 -0400
Received: from fr1.as29.net ([62.210.131.231]:38685 "EHLO
	toothrot.meleeweb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaHSS5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:57:50 -0400
From: Bertrand Jacquin <beber@meleeweb.net>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Cc: Bertrand Jacquin <beber@meleeweb.net>, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCHv2 0/3] handle module compression at install
Date: Tue, 19 Aug 2014 20:57:37 +0200
Message-Id: <1408474660-24999-1-git-send-email-beber@meleeweb.net>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is patchset based on commit 480cadc (v3.17-rc1-22-g480cadc) that
aims to handle kernel modules compression while running make modules_install.

Please Cc me, as I'm not subscribed to LKML.

Changes since v1:

 - Drop -9 argument to gzip and xz since Andi Kleen and Rusty Russell
   prove no gain is made using them.

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

