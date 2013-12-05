Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3LEUqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:46:11 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:60528 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3LEUqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:46:09 -0500
Message-ID: <52A0E610.4050307@tilera.com>
Date: Thu, 5 Dec 2013 15:46:08 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile ftrace bug fix for v3.13
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following change for 3.13 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This fixes a build failure with allyesconfig reported by Fengguang Wu
and fixed by Tony Lu.

Tony Lu (1):
      ftrace: default to tilegx if ARCH=tile is specified

 scripts/recordmcount.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

