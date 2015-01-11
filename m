Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbbAKXmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:42:53 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:59171 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbAKXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:42:51 -0500
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
Subject: [PATCH v4 0/2] lprocfs_write_frac_u64_helper cleanup
Date: Sun, 11 Jan 2015 17:42:27 -0600
Message-Id: <1421019749-25110-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed "drivers" from the subject.  I saw examples of this in the
commit log but have since realized this is not preferred.

v3:

Added Andreas as reviewer (thanks!)

v2:

Added a second patch to address Dan Carpenter's concern with the
complexity of passing the sign through `mult'.  Compile tested only.

Chris Rorvick (2):
  staging: lustre: Use mult if units not specified
  staging: lustre: Track sign separately

 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.1.0

