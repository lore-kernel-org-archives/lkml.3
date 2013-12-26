Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3LZS51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:57:27 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50019 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab3LZS50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:57:26 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/11] Staging: vt6656: Cleanup of checkpatch problems in bssdb.c
Date: Thu, 26 Dec 2013 19:55:29 +0100
Message-Id: <1388084140-21562-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series reformats the bssdb.c file of the vt6656 driver in
staging. It resolves all errors and some warnings which checkpatch.pl
discovered.

As requested, the changes are now split into a series of smaller,
fine-grained patches. The reference git tree, that was used to create
it this time, is linux-next.

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

