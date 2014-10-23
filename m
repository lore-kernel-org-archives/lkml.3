Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaJWWNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:13:36 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:56250 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaJWWNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:13:34 -0400
Date: Thu, 23 Oct 2014 17:11:21 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] staging: skein: Adds CryptoAPI and Module Support
Message-ID: <cover.1414102205.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CryptoAPI and Loadable Module support to the Skein Hashing
Algorithm.

Eric Rost (2):
  staging: skein: Adds CryptoAPI Support
  staging: skein: Adds Loadable Module Support

 drivers/staging/skein/Kconfig         |  24 +-
 drivers/staging/skein/Makefile        |  13 +-
 drivers/staging/skein/skein.c         | 883 ---------------------------------
 drivers/staging/skein/skein.h         | 346 -------------
 drivers/staging/skein/skein_api.h     |   2 +-
 drivers/staging/skein/skein_base.c    | 884 ++++++++++++++++++++++++++++++++++
 drivers/staging/skein/skein_base.h    | 351 ++++++++++++++
 drivers/staging/skein/skein_block.c   |   2 +-
 drivers/staging/skein/skein_block.h   |   2 +-
 drivers/staging/skein/skein_generic.c | 211 ++++++++
 drivers/staging/skein/skein_iv.h      |   2 +-
 drivers/staging/skein/threefish_api.h |   2 +-
 12 files changed, 1462 insertions(+), 1260 deletions(-)
 delete mode 100644 drivers/staging/skein/skein.c
 delete mode 100644 drivers/staging/skein/skein.h
 create mode 100644 drivers/staging/skein/skein_base.c
 create mode 100644 drivers/staging/skein/skein_base.h
 create mode 100644 drivers/staging/skein/skein_generic.c

-- 
2.1.1

