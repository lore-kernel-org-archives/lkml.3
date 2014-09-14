Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaINFLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:11:08 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:52505 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaINFLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:11:06 -0400
Date: Sun, 14 Sep 2014 01:07:06 -0400
From: Jon Mason <jdmason@kudzu.us>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] NTB bug fixes for v3.17
Message-ID: <20140914050705.GA12962@kudzu.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, 
Below are a few NTB bug fixes for v3.17. Please consider pulling them.

Thanks, 
Jon

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://github.com/jonmason/ntb tags/ntb-3.17

for you to fetch changes up to 3cc5ba1938eea0de372a41d1687c8030049c5e8f:

  ntb: Add alignment check to meet hardware requirement (2014-09-14 00:10:38 -0400)

----------------------------------------------------------------
NTB driver fixes for queue spread and buffer alignment.  Also, update to
MAINTAINERS to reflect new e-mail address.

----------------------------------------------------------------
Dave Jiang (1):
      ntb: Add alignment check to meet hardware requirement

Jon Mason (2):
      NTB: correct the spread of queues over mw's
      MAINTAINERS: update NTB info

 MAINTAINERS                 |  3 ++-
 drivers/ntb/ntb_transport.c | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)
