Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbbARObW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:31:22 -0500
Received: from mout.web.de ([212.227.15.3]:64180 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbbARObU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:31:20 -0500
Message-ID: <54BBC3AB.6040207@users.sourceforge.net>
Date: Sun, 18 Jan 2015 15:31:07 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com,
        linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/3] block: Deletion of checks before three function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:+8kHET24s0ZyonQ8MjFSKrZTABBKnR1VgafjnewMO4hv6VB3nFW
 6UcEw5X90ao6MREX33HwGTePNOQzN+gnm6W30Yxss7AIHmfuZ3lGzhV7yAlhX0H32/Agr+H
 CAiX8elZG9JgrcsWrw6k0CIAVnmcnPAvgUlcZaQCTJisrp3QKJIy7SQ8VEQMI80OuOhYa9x
 TSRqQ04JU2ZVFj0jvORPg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 14:50:06 +0100

Functions which release a system resource are occasionally documented in the way
that they tolerate the passing of a null pointer for example. I do not see a need
because of this fact that a function caller repeats a corresponding check.

Markus Elfring (3):
  cciss: Deletion of an unnecessary check before the function call "put_disk"
  z2ram: Delete an unnecessary check before the function call "kfree"
  Deletion of checks before the function call "iounmap"

 drivers/block/cciss.c    | 18 ++++++------------
 drivers/block/mg_disk.c  |  3 +--
 drivers/block/skd_main.c |  6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

-- 
2.2.2

