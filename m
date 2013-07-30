Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3G2Xlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:41:35 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:56759 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3G2Xle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:41:34 -0400
Message-ID: <51F7AD7A.2090901@synopsys.com>
Date: Tue, 30 Jul 2013 05:11:38 -0700
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ARC fix for 3.11
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.21.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a build breakage for ARC.

Thx,
-Vineet

------------------------->
The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.11-fixes

for you to fetch changes up to 4ffd9e2c4deda2ad90ce261174b2bc90e0660703:

  ARC: SMP build breakage (2013-07-26 15:34:22 -0700)

----------------------------------------------------------------
SMP build breakage

----------------------------------------------------------------
Vineet Gupta (1):
      ARC: SMP build breakage

 arch/arc/include/asm/entry.h | 1 +
 1 file changed, 1 insertion(+)
