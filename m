Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3LDCm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:42:29 -0500
Received: from mdfmta009.mxout.tch.inty.net ([91.221.169.50]:50018 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755317Ab3LDCm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:42:26 -0500
Message-ID: <529E968D.7010108@lougher.demon.co.uk>
Date: Wed, 04 Dec 2013 02:42:21 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs bug fixes for 3.13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs bug fix.

Thanks

Phillip

The following changes since commit ed4f381ec15e5f11724cdbc68cffd2c22d1eaebd:

   Squashfs: Check stream is not NULL in decompressor_multi.c (2013-11-20 03:59:20 +0000)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git tags/squashfs-fixes

for you to fetch changes up to 6d565409503f4e1f74ac30de14e8c91a2b826cd8:

   Squashfs: fix failure to unlock pages on decompress error (2013-11-24 01:02:50 +0000)

----------------------------------------------------------------
Just a single bug fix to the new "directly decompress into the
page cache" code.

----------------------------------------------------------------
Phillip Lougher (1):
       Squashfs: fix failure to unlock pages on decompress error

  fs/squashfs/file_direct.c | 5 ++++-
  1 file changed, 4 insertions(+), 1 deletion(-)
