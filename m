Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3LSPh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:37:27 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56881 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551Ab3LSPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:37:24 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux@rationality.eu, linux-kernel@i4.cs.fau.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tvboxspy@gmail.com, more.andres@gmail.com, gregkh@linuxfoundation.org,
        forest@alittletooquiet.net
Subject: [PATCH 0/2] vt6656: Cleanup of checkpatch problems in bssdb.c
Date: Thu, 19 Dec 2013 16:27:04 +0100
Message-Id: <1387466826-2410-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series reformats the bssdb.c file of the vt6656 driver in
staging. It resolves all errors and some warnings which checkpatch.pl
discovered.

However some occurrences of the following warnings are not patched:
- Lines over 80 characters
- Too many indentation levels
- printk should include KERN_ facility level

The first two noted types of warnings require more code modification
to reduce the indentation level. The latter should be fixed along with
the removal of the custom printk macro in
drivers/staging/vt6656/device.h.

NOTE: As the first patch retabs the complete file, you might consider
using "git diff --ignore-all-space"

No functional changes should be introduced by these patches.

This file was already changed in linux-next to some degree, but still
does not conform to the linux coding style. Nevertheless, we submit
this patch series since we fix more coding style problems. However
we welcome any recommendations concerning this conflict.

