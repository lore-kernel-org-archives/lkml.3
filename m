Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3EVPqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:46:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47471 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab3EVPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:46:11 -0400
Date: Wed, 22 May 2013 10:43:03 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PULL] TPM driver updates
Message-ID: <20130522154302.GA1509@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052215-7182-0000-0000-000006D487D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

The following changes since commit 4726e8fa1dcad533362475ebf91f70d5b6b6292f:

  security: clarify cap_inode_getsecctx description (2013-05-12 21:32:38 +1000)

are available in the git repository at:

  git://github.com/shpedoikal/linux.git tpmdd-05-21-13

for you to fetch changes up to 1c16c9636cad24f0e654f19e8f73ede0c7bd5540:

  tpm: move TPM_DIGEST_SIZE defintion (2013-05-21 12:25:02 -0500)

----------------------------------------------------------------
Mimi Zohar (1):
      tpm: move TPM_DIGEST_SIZE defintion

Wei Yongjun (1):
      tpm_tis: missing platform_driver_unregister() on error in init_tis()

 drivers/char/tpm/tpm.h     |  1 -
 drivers/char/tpm/tpm_tis.c | 17 ++++++++++++-----
 include/linux/tpm.h        |  2 ++
 3 files changed, 14 insertions(+), 6 deletions(-)

