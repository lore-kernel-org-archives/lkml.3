Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3JKG3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:29:21 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:56576 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab3JKG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:29:19 -0400
Message-ID: <525799AC.4090201@synopsys.com>
Date: Fri, 11 Oct 2013 11:54:44 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        anton Kolesov <Anton.Kolesov@synopsys.com>
Subject: [GIT PULL] ARC fix for 3.12.-rc5
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a gdb related fix. This release, we've had more pull requests than
usual. Next time around I'll try to hold on to them for a bit before sending over.

Thx,
-Vineet

----------->
The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/

for you to fetch changes up to b0b080d7884be5acdd6d519c325bef3443587ad6:

  ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"
(2013-10-11 11:25:04 +0530)

----------------------------------------------------------------
Fix for a gdb corner case breakage

----------------------------------------------------------------
Vineet Gupta (1):
      ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

 arch/arc/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
