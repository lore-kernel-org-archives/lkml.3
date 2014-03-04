Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaCDHNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:13:09 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44862 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbaCDHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:06 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 0/9] drivers: staging: rtl8187se: various code cleanups
Date: Tue,  4 Mar 2014 00:12:48 -0700
Message-Id: <cover.1393916553.git.axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches fixes a substantial number of checkpatch.pl errors and warnings, and additionally it refactors some sections of code where lines were far too long due to organizational problems.

This second version of the patch set addresses some embarrassingly obvious issues in the original set of patches.

Axel Rasmussen (9):
  drivers: staging: rtl8187se: use netdev_* instead of prink
  drivers: staging: rtl8187se: refactor/clean signal smoothing
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: fixed broken indentation
  drivers: staging: rtl8187se: fixed checkpatch.pl errors
  drivers: staging: rtl8187se: wrap excessively long lines
  drivers: staging: rtl8187se: refactor wmm_param_update

 drivers/staging/rtl8187se/Module.symvers |   0
 drivers/staging/rtl8187se/r8180.h        |   2 +-
 drivers/staging/rtl8187se/r8180_core.c   | 638 ++++++++++++++++++-------------
 3 files changed, 372 insertions(+), 268 deletions(-)
 create mode 100644 drivers/staging/rtl8187se/Module.symvers

-- 
1.8.3.2

