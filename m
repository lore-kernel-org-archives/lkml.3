Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3LQWNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:13:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19637 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3LQWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:13:38 -0500
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: Re: [PATCH 3.5 037/103] [SCSI] Disable WRITE SAME for RAID and virtual host adapter drivers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
	<1387304012-23805-38-git-send-email-luis.henriques@canonical.com>
Date: Tue, 17 Dec 2013 17:13:26 -0500
In-Reply-To: <1387304012-23805-38-git-send-email-luis.henriques@canonical.com>
	(Luis Henriques's message of "Tue, 17 Dec 2013 18:12:26 +0000")
Message-ID: <yq1vbyn6s8p.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Luis" == Luis Henriques <luis.henriques@canonical.com> writes:

Luis> 3.5.7.28 -stable review patch.  If anyone has any objections,
Luis>          please let me know.

Luis>   - dropped changes to drivers/scsi/sd.c ]

WRITE SAME support didn't go in until 3.7. And without the sd.c pieces
the patch doesn't actually do anything.

-- 
Martin K. Petersen	Oracle Linux Engineering
