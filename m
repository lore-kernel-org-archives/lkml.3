Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab3E1K3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3E1K3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:29:43 -0400
Date: Tue, 28 May 2013 12:29:41 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.23.1 (stable)
Message-ID: <20130528102941.GA20866@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The util-linux stable release v2.23.1 is available at
       
    ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.23
                
Feedback and bug reports, as always, are welcomed.
                 
   Karel



Util-linux 2.23.1 Release Notes
===============================

blkid:
   - fix typo in ID_FS_AMBIVALEN=  [Karel Zak]
build-sys:
   - add --disable-setterm  [Karel Zak]
   - always check for setns() and unshare() libs functions  [Karel Zak]
   - use -Wno-clobbered for some BSD crap  [Karel Zak]
chcpu:
   - clean up error messages  [Karel Zak]
lib/loopdev:
   - fix loopcxt_check_size() to work with blkdevs  [Karel Zak]
lib/tty:
   - don't hardcode terminal fd in get_terminal_name()  [Karel Zak]
   - fix get_terminal_name() usage, cleanup code  [Karel Zak]
libblkid:
   - add ReFS magic string  [Karel Zak]
   - fix blkid_parse_tag_string() to ignore incomplete tags  [Karel Zak]
libfdisk:
   - do not use va_list in the Ask API  [Karel Zak]
libmount:
   - don't ignore root fs on umount -a  [Karel Zak]
   - use MS_SILENT for /{proc,etc}/filesystems  [Karel Zak]
losetup:
   - use warn_size() for regular files only  [Karel Zak]
lsblk:
   - add SERIAL column  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]
   - update vi.po (from translationproject.org)  [Trần Ngọc Quân]
   - update zh_CN.po (from translationproject.org)  [Wylmer Wang]
sfdisk:
   - don't call BLKRRPART for non-block devices  [Karel Zak]
sulogin:
   - clean up error messages  [Karel Zak]
tests:
   - new warning fix  [Gilles Espinasse]

- standard SEE ALSO section of man pages  [Mike Frysinger]

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
