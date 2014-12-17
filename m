Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaLQEYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:24:32 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:57861 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLQEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:24:31 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Chris Rorvick <chris@rorvick.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] lprocfs_write_frac_u64_helper cleanup
Date: Tue, 16 Dec 2014 22:24:00 -0600
Message-Id: <1418790242-14309-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a second patch to address Dan Carpenter's concern with the
complexity of passing the sign through `mult'.  Compile tested only.

Chris Rorvick (2):
  drivers: staging: lustre: Use mult if units not specified
  drivers: staging: lustre: Track sign separately

 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.1.0

