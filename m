Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967435Ab3DRPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:37:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60620 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967315Ab3DRPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:37:26 -0400
Date: Thu, 18 Apr 2013 10:30:27 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PULL] TPM driver updates
Message-ID: <20130418153025.GA12339@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041815-3620-0000-0000-000002176F08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

The following changes since commit 958d2c2f4ad905e3ffa1711d19184d21d9b00cc1:

  Smack: include magic.h in smackfs.c (2013-04-03 13:13:51 +1100)

are available in the git repository at:

  git://github.com/shpedoikal/linux.git tpmdd-04-17-13

for you to fetch changes up to 32d33b29ba077d6b45de35f2181e0a7411b162f4:

  TPM: Retry SaveState command in suspend path (2013-04-17 09:31:32 -0500)

----------------------------------------------------------------
Chen Gang (1):
      drivers/char/tpm/tpm_ppi: use strlcpy instead of strncpy

Duncan Laurie (1):
      TPM: Retry SaveState command in suspend path

Peter Huewe (4):
      tpm/tpm_i2c_stm_st33: formatting and white space changes
      tpm: Add support for new Infineon I2C TPM (SLB 9645 TT 1.2 I2C)
      tpm/tpm_i2c_infineon.c: Add OF attributes type and name to the of_device_id table entries
      tpm/tpm_i2c_infineon: Add small comment about return value of __i2c_transfer

Sachin Kamat (1):
      tpm_i2c_stm_st33: Remove duplicate inclusion of header files

Shubhrajyoti Datta (1):
      char/tpm: Convert struct i2c_msg initialization to C99 format

 .../devicetree/bindings/i2c/trivial-devices.txt    |   2 +
 drivers/char/tpm/tpm.c                             |  31 +++-
 drivers/char/tpm/tpm.h                             |   3 +
 drivers/char/tpm/tpm_i2c_infineon.c                | 180 ++++++++++++++++-----
 drivers/char/tpm/tpm_i2c_stm_st33.c                |  64 ++++----
 drivers/char/tpm/tpm_ppi.c                         |  14 +-
 6 files changed, 207 insertions(+), 87 deletions(-)

