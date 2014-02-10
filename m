Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaBJA5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:57:32 -0500
Received: from seketeli.net ([94.23.218.202]:53337 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaBJA5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:57:30 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] Add documentation on writing an musb glue layer
Date: Mon, 10 Feb 2014 01:48:20 +0100
Message-Id: <1391993302-4016-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following a few patches that add support for the USB device controller
of the Ingenic JZ4740 MIPS SoC, I documented the process of writing an
MUSB glue layer.
The JZ4740 MUSB controller offers a basic feature set, which makes the
glue layer implementation more simple than most current glue layers in
tree.

The patch that comes as a follow-up of this message is an attempt to
provide a step-by-step walk-through of the process of writing an MUSB
glue layer.

Changes were rebased on top of Linus Torvalds' tree, with the
documentation built and tested successfully.

The following changes since commit 9c1db7798141e2658e4b5bb170128dfdc3270ff4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs

are available in the git repository at:

  git://git.seketeli.net/~apelete/linux.git writing-musb-glue-layer

Apelete Seketeli (1):
  documentation: docbook: document writing an musb glue layer

 Documentation/DocBook/Makefile                     |    3 +-
 Documentation/DocBook/writing_musb_glue_layer.tmpl |  868 ++++++++++++++++++++
 2 files changed, 870 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/DocBook/writing_musb_glue_layer.tmpl

-- 
1.7.10.4

