Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbaGYSu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:50:59 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35774 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbaGYSu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:50:58 -0400
Date: Fri, 25 Jul 2014 11:50:48 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PULL] fw-restrict update (3.17)
Message-ID: <20140725185048.GA27939@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull these fw-restrict changes for 3.17. Thanks!

-Kees

The following changes since commit 7d8b6c63751cfbbe5eef81a48c22978b3407a3ad:

  CAPABILITIES: remove undefined caps from all processes (2014-07-24 21:53:47 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/fw-restrict-3.17

for you to fetch changes up to 5a9196d715607f76d6b7d96a0970d6065335e62b:

  ima: add support for measuring and appraising firmware (2014-07-25 11:47:46 -0700)

----------------------------------------------------------------
Firmware validation hooks

----------------------------------------------------------------
Kees Cook (2):
      security: introduce kernel_fw_from_file hook
      firmware_class: perform new LSM checks

Mimi Zohar (1):
      ima: add support for measuring and appraising firmware

 Documentation/ABI/testing/ima_policy  |  4 +++-
 drivers/base/firmware_class.c         | 30 ++++++++++++++++++++++++++----
 include/linux/ima.h                   |  6 ++++++
 include/linux/security.h              | 17 +++++++++++++++++
 security/capability.c                 |  6 ++++++
 security/integrity/ima/ima.h          |  3 ++-
 security/integrity/ima/ima_appraise.c |  8 ++++++++
 security/integrity/ima/ima_main.c     | 11 +++++++++++
 security/integrity/ima/ima_policy.c   |  7 +++++++
 security/integrity/integrity.h        |  9 +++++++--
 security/security.c                   | 11 +++++++++++
 11 files changed, 104 insertions(+), 8 deletions(-)

-- 
Kees Cook
Chrome OS Security
