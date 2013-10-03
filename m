Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3JCMtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:49:33 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:54769 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3JCMtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:49:32 -0400
Message-ID: <524D67CF.9020809@synopsys.com>
Date: Thu, 3 Oct 2013 18:19:19 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Subject: [GIT PULL] Urgent ARC fix for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Chrisitian found/fixed issue with SA_SIGINFO based signal handler corrupting the
user space registers post after signal handling.

Please pull.

Thx,
-Vineet
-------------------->
The following changes since commit 55c2e26204276b27f2b7a63123b701c950e45d89:

  ARC: Use clockevents_config_and_register over clockevents_register_device
(2013-09-27 16:28:48 +0530)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ for-curr

for you to fetch changes up to 10469350e345599dfef3fa78a7c19fb230e674c1:

  ARC: Fix signal frame management for SA_SIGINFO (2013-10-03 09:43:56 +0530)

----------------------------------------------------------------
Args to SA_SIGINFO signal handler corrupting corresponding user space registers

----------------------------------------------------------------
Christian Ruppert (1):
      ARC: Fix signal frame management for SA_SIGINFO

 arch/arc/kernel/signal.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)
