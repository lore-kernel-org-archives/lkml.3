Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3LTHha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:37:30 -0500
Received: from smtp-relay.synopsys.com ([198.182.44.80]:53557 "EHLO
	smtp-relay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3LTHh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:37:29 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [GUT PULL] ARC fix for 3.13-rc5
Thread-Topic: [GUT PULL] ARC fix for 3.13-rc5
Thread-Index: Ac79Vk3bzPhv/pqxRlSsqXNOQNVlbw==
Date: Fri, 20 Dec 2013 07:37:20 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075172C3D@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a regression introduced in prev rc. Please merge.

Thx,
-Vineet
---------------------->
The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-fixes-for-3.13-rc5

for you to fetch changes up to 1e01c7eb7c431a74437d73fe54670398b4d2b222:

  ARC: Allow conditional multiple inclusion of uapi/asm/unistd.h (2013-12-19
19:44:12 +0530)

----------------------------------------------------------------
syscall table busted due to unistd header inclusion issue

----------------------------------------------------------------
Vineet Gupta (1):
      ARC: Allow conditional multiple inclusion of uapi/asm/unistd.h

 arch/arc/include/uapi/asm/unistd.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
