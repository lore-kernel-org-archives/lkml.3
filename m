Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3E0UNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:13:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:52256 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab3E0UNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:13:08 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+XmRFC2e+XjV02O8fAHoj+laK7hmMPS3C0SraoNP
	wBg0s5obELPpIh
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Subject: [PULL] TPM: fix regression caused by section type conflict of tpm_dev_release() in ppc builds
Date: Mon, 27 May 2013 22:18:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Tony Camuso <tcamuso@redhat.com>, linux-kernel@vger.kernel.org,
        LeonidasDaSilvaBarbosa <leosilva@linux.vnet.ibm.com>,
        AshleyLai <ashley@ashleylai.com>, sfr@canb.auug.org.au,
        tpmdd-devel@lists.sourceforge.net
References: <51A39A0C.8040405@redhat.com> <1369684307-11014-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369684307-11014-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305272218.41915.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

The following changes since commit 5b88e270253db6d817e6a2f61909d1e53620e990:

 maintainers: Remove Kent from maintainers	

are available in the git repository at:

  git://github.com/PeterHuewe/linux-tpmdd.git for-james

for you to fetch changes up to e2fa3d799b7471f00adae59ff36260ad8237929f:

 tpm: fix regression caused by section type conflict of tpm_dev_release() in ppc builds

----------------------------------------------------------------
Peter Huewe (1):
      tpm: fix regression caused by section type conflict of tpm_dev_release() in ppc builds

 drivers/char/tpm/tpm.c | 2 +-
 drivers/char/tpm/tpm.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Thanks,
Peter
