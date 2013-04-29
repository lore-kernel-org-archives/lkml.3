Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab3D2LSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:18:06 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:49748 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab3D2LSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:18:04 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 07:18:04 EDT
Message-ID: <517E5540.F64D5681@users.sourceforge.net>
Date: Mon, 29 Apr 2013 14:10:56 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.6h file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed bug that caused compile failure if kernel configuration has
  CONFIG_UIDGID_STRICT_TYPE_CHECKS=y. Patch from Hank Leininger.
- Worked around block layer interface changes on 3.9 kernels.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6h.tar.bz2
    md5sum 7c5ad5761e58fc8eb0176b00c69b6b75

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6h.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
