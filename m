Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3HZPbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:31:46 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:35125 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab3HZPbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:31:44 -0400
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 11:31:44 EDT
Message-ID: <521B7243.B0C3CC11@users.sourceforge.net>
Date: Mon, 26 Aug 2013 18:20:35 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.7a file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Code and struct cleanup, make it work on 3.11-rc kernels.
- Fixed directory permissions bug in util-linux-2.23.2 when "mount -a" set
  up encrypted file system using ramdom keys. util-linux-2.21.2 and older
  versions are not affected.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7a.tar.bz2
    md5sum f267cb2108ee94b09a30b2fc7e292104

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
