Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaFXR2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:28:15 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:32843 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbaFXR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:28:12 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/6] Remove various orphaned header files
Date: Tue, 24 Jun 2014 19:27:29 +0200
Message-Id: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAICT, these headers are not used anywhere, and are just accidental
leftovers from past cleanups.

Rasmus Villemoes (6):
  include/linux/cycx_x25.h: Remove unused header
  include/linux/i82593.h: Remove unused header
  include/linux/mfd/ti_ssp.h: Remove unused header
  include/linux/phonedev.h: Remove unused header
  include/linux/platform_data/tegra_emc.h: Remove unused header
  include/rxrpc/types.h: Remove unused header

 include/linux/cycx_x25.h                | 125 -----------------
 include/linux/i82593.h                  | 229 --------------------------------
 include/linux/mfd/ti_ssp.h              |  93 -------------
 include/linux/phonedev.h                |  25 ----
 include/linux/platform_data/tegra_emc.h |  34 -----
 include/rxrpc/types.h                   |  41 ------
 6 files changed, 547 deletions(-)
 delete mode 100644 include/linux/cycx_x25.h
 delete mode 100644 include/linux/i82593.h
 delete mode 100644 include/linux/mfd/ti_ssp.h
 delete mode 100644 include/linux/phonedev.h
 delete mode 100644 include/linux/platform_data/tegra_emc.h
 delete mode 100644 include/rxrpc/types.h

-- 
1.9.2

