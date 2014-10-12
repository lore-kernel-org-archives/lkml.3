Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJLSr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:47:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57880 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLSrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:47:25 -0400
From: Koray Gulcu <koray.gulcu@ozu.edu.tr>
To: gregkh@linuxfoundation.org
Cc: peter.p.waskiewicz.jr@intel.com, antoine@schweitzer-chaput.fr,
        anarey@gmail.com, c@24.io, rickard_strandqvist@spectrumdigital.se,
        teobaluta@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: rtl8192u: Fix sparse warnings
Date: Sun, 12 Oct 2014 19:46:49 +0100
Message-Id: <1413139611-22074-1-git-send-email-koray.gulcu@ozu.edu.tr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes some endianness warnings detected by sparse. The second patch amends lines with more than 80 characters in the firs patch.

Koray Gulcu (2):
  staging:rtl8192u: Fix sparse warnings of r8182U_core
  staging:rtl8192u: Fix checkpatch.pl warnings

 drivers/staging/rtl8192u/r8192U_core.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

-- 
1.7.10.4

