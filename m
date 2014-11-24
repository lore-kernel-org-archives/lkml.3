Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaKXRAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:00:31 -0500
Received: from mout.web.de ([212.227.15.4]:61374 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaKXRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:00:29 -0500
Message-ID: <54736422.90409@users.sourceforge.net>
Date: Mon, 24 Nov 2014 18:00:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org
CC: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Fix a few typos around the word "destroy"
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ubAE8dXYJbd/7GBxM4g9ltgFslm4UUUp1mSJfuQW9SJgUunM0L6
 WQDnRhZupdnj8F7VqD50IrjKMxpXXBKZCiJckD0/voRvGsX8rmxdk8x6wy8cOQian+5Ghe+
 QagtFATug0DIgKpgmd+KKPctMf/FeQbuvtuc3EYfK/EGKTLflFb07tUYkvVPTF+0pcUcFVj
 C1YjSLM02DSkmT7mkCB5g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 17:34:23 +0100
Subject: [PATCH 0/6] Fix a few typos around the word "destroy"

The word "destroy" was mistyped in some files.

Markus Elfring (6):
  isci: Fix a typo for the word "destroy"
  SCSI-libfc: Fix typos for the word "destroy"
  video: fbdev-MMP: Fix typos for the word "destroy"
  f2fs: Fix typos for the word "destroy" in jump labels
  video: fbdev-MMP: Fix a typo for the word "destroyed"
  Documentation-SCSI: Fix a typo for the word "destroy"

 Documentation/scsi/ChangeLog.lpfc | 2 +-
 drivers/scsi/isci/remote_device.c | 2 +-
 drivers/scsi/libfc/fc_fcp.c       | 4 ++--
 drivers/video/fbdev/mmp/core.c    | 6 +++---
 fs/f2fs/node.c                    | 8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.1.3

