Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaJXL47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:56:59 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:48867 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbaJXL46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:56:58 -0400
Date: Fri, 24 Oct 2014 06:54:46 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/7] staging: skein: CryptoAPI and Module Support
Message-ID: <cover.1414151639.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CryptoAPI and Module support to Skein Hash Algorithm. Also inlines
rotl_64 macro, and removes nonexistent header references.

Eric Rost (7):
  staging: skein: Collapses threefish module
  staging: skein: Renames skein to skein_base
  staging: skein: Adds CryptoAPI Support
  staging: skein: Adds Loadable Module Support
  staging: skein: Inlines rotl_64
  staging: skein: Removes unneeded #define
  staging: skein: Removes skein_debug include

 drivers/staging/skein/Kconfig         |  24 +-
 drivers/staging/skein/Makefile        |  13 +-
 drivers/staging/skein/skein.c         | 883 ----------------------------------
 drivers/staging/skein/skein.h         | 346 -------------
 drivers/staging/skein/skein_api.h     |   2 +-
 drivers/staging/skein/skein_base.c    | 882 +++++++++++++++++++++++++++++++++
 drivers/staging/skein/skein_base.h    | 345 +++++++++++++
 drivers/staging/skein/skein_block.c   |   2 +-
 drivers/staging/skein/skein_block.h   |   2 +-
 drivers/staging/skein/skein_generic.c | 208 ++++++++
 drivers/staging/skein/skein_iv.h      |   2 +-
 drivers/staging/skein/threefish_api.h |   2 +-
 12 files changed, 1451 insertions(+), 1260 deletions(-)
 delete mode 100644 drivers/staging/skein/skein.c
 delete mode 100644 drivers/staging/skein/skein.h
 create mode 100644 drivers/staging/skein/skein_base.c
 create mode 100644 drivers/staging/skein/skein_base.h
 create mode 100644 drivers/staging/skein/skein_generic.c

-- 
2.1.1

