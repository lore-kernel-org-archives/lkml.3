Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3CHWdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:33:50 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:34801 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3CHWdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:33:49 -0500
Message-ID: <513A6749.7000901@tilera.com>
Date: Fri, 8 Mar 2013 17:33:45 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [GIT PULL] arch/tile bug fixes for v3.9
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.9 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This fixes the bug that Al Viro spotted with the compat llseek code.
I also fixed the compat syscall definitions to use the new syscall
define macros to properly sign-extend their arguments.

Chris Metcalf (2):
      tile: work around bug in the generic sys_llseek
      tile: properly use COMPAT_SYSCALL_DEFINEx

 arch/tile/include/asm/compat.h |    3 +++
 arch/tile/kernel/compat.c      |   42 +++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 13 deletions(-)
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

