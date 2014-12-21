Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaLUREk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:04:40 -0500
Received: from mail-yk0-f182.google.com ([209.85.160.182]:59476 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaLUREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:04:38 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] lprocfs_write_frac_u64_helper cleanup
Date: Sun, 21 Dec 2014 11:04:03 -0600
Message-Id: <1419181445-15031-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Andreas as reviewer (thanks!)

v2:

Added a second patch to address Dan Carpenter's concern with the
complexity of passing the sign through `mult'.  Compile tested only.

Chris Rorvick (2):
  drivers: staging: lustre: Use mult if units not specified
  drivers: staging: lustre: Track sign separately

 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.1.0

