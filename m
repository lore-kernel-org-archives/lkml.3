Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3FFTQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:16:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59344 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3FFTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:16:38 -0400
Date: Thu, 06 Jun 2013 12:16:35 -0700 (PDT)
Message-Id: <20130606.121635.836050550847993594.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a quick one commit pull request to cure the
regression introduced by the MSG_CMSG_COMPAT change.

Please pull, thanks a lot!

The following changes since commit 4d3797d7e1861ac1af150a6189315786c5e1c820:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-05 19:19:04 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to a7526eb5d06b0084ef12d7b168d008fcf516caab:

  net: Unbreak compat_sys_{send,recv}msg (2013-06-06 11:52:14 -0700)

----------------------------------------------------------------
Andy Lutomirski (1):
      net: Unbreak compat_sys_{send,recv}msg

 include/linux/socket.h |  3 +++
 net/compat.c           | 13 +++++++++++--
 net/socket.c           | 72 +++++++++++++++++++++++++++++++++---------------------------------------
 3 files changed, 47 insertions(+), 41 deletions(-)
