Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab3DAO0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 10:26:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:23910 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3DAO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 10:26:33 -0400
Message-ID: <51599918.4040706@tilera.com>
Date: Mon, 1 Apr 2013 10:26:32 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile fix for v3.9
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following change for 3.9 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This change allows newer Tilera boot tools to work correctly with current
(and stable) kernels by using the right filename to get the initramfs from
the Tilera hypervisor filesystem.

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

 arch/tile/kernel/setup.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

