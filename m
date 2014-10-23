Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbaJWCYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:24:33 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:52391 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaJWCYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:24:32 -0400
Date: Wed, 22 Oct 2014 21:22:18 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] staging: skein: Add Crypto API and Loadable Module
 support
Message-ID: <cover.1414030776.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds crypto api support and loadable module support to the
skein driver.

Eric Rost (2):
  staging: skein: Add Crypto API support
  staging: skein: Add Loadable Module Support

 drivers/staging/skein/Kconfig         |  24 +---
 drivers/staging/skein/Makefile        |  13 +-
 drivers/staging/skein/skein.c         |   1 +
 drivers/staging/skein/skein.h         |   5 +
 drivers/staging/skein/skein_generic.c | 231 ++++++++++++++++++++++++++++++++++
 5 files changed, 248 insertions(+), 26 deletions(-)
 create mode 100644 drivers/staging/skein/skein_generic.c

-- 
2.1.1

