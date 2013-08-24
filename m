Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3HXGjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 02:39:12 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:53229 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3HXGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 02:39:10 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Joern Rennecke <joern.rennecke@embecosm.com>,
        Noam Camus <noamc@ezchip.com>, <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] ARC Bug fix for 3.11-rc7
Date: Sat, 24 Aug 2013 12:03:05 +0530
Message-ID: <1377325986-18974-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a serious bug fix in Big Endian configuration. I know it's late, but
we need this fix. Please consider applying for 3.11-rc7.
I hope direct email as opposed to a formal pull request is OK.

P.S. @Greg, I can vouch for this fix, can you please queue this up for next
stable and not wait for -rc to come out.

Thx,
-Vineet

Joern Rennecke (1):
  ARC: [lib] strchr breakage in Big-endian configuration

 arch/arc/lib/strchr-700.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
1.8.1.2

