Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab3GaMvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab3GaMvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:51:51 -0400
Date: Wed, 31 Jul 2013 14:51:48 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.23.2
Message-ID: <20130731125148.GA1127@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The util-linux stable bugfix release v2.23.2 is available at

  ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.23

Feedback and bug reports, as always, are welcomed.

  Karel



Util-linux 2.23.2 Release Notes
===============================

agetty:
   - don't remove ECHOCTL from c_lflag  [Karel Zak]
   - fix a kill/erase error in man page and improve clarity  [Benno Schulenberg]
   - fix memory leak [clang-analyzer]  [Sami Kerola]
   - update man page and usage()  [Karel Zak]
   - unrecognized option '--loginpause'"  [kernc]
cal:
   - fix -y output for UTF8  [Karel Zak]
column:
   - dereference of null pointer [clang-analyzer]  [Sami Kerola]
dmesg:
   - don't use pager for --follow  [Karel Zak]
docs:
   - update AUTHORS file  [Karel Zak]
eject:
   - unlock door before issuing CDROMEJECT command  [Aaron Lu]
exec_shell:
   - add a license and touch up func def  [Mike Frysinger]
fdisk:
   - add support for the MicroBlaze architecture  [Nathan Rossi]
findmnt:
   - avoid unused parameter warning  [Karel Zak]
   - make udev usage more robust  [Karel Zak]
   - test for fstype/options/maj min before source and target  [Karel Zak]
getopt:
   - add reference to /usr/share/docs to man page  [Karel Zak]
hwclock:
   - remove references to adjtimex from man page  [Karel Zak]
libmount:
   - be robust for empty target/source strings  [Karel Zak]
   - fix memory leak [clang-analyzer]  [Karel Zak]
   - more robust options string parsing  [Karel Zak]
login:
   - use TCSANOW to remove HUPCL  [Karel Zak]
losetup:
   - set errno for misaligned offsets  [Karel Zak]
lsblk:
   - use devno to get mountpoint  [Karel Zak]
mkfs.bfs:
   - fix 64-Bit and endian problems  [ihno]
mkfs.cramfs:
   - argument to free() is a constant address [clang-analyzer]  [Sami Kerola]
mount:
   - (deprecated) fix typo tailed->failed  [Yuri Chornoivan]
   - fix mistaken word and some grammar in man page of mount  [Benno Schulenberg]
   - remove repeating words from mount.8  [Karel Zak]
   - update xfs docs  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update cs.po (from translationproject.org)  [Petr Písař]
   - update fr.po (from translationproject.org)  [David Prévot]
   - update pl.po (from translationproject.org)  [Jakub Bogusz]
   - update uk.po (from translationproject.org)  [Yuri Chornoivan]
renice:
   - exit with non-zero value when arguments cause warnings  [Sami Kerola]
runuser:
   - update man page, add note about -l vs. -p  [Karel Zak]
sfdisk:
   - don't use word 'disk'.  [Karel Zak]
su:
   - ignore --preserve-environment, it's mutually exclusive to --login  [Karel Zak]
sulogin:
   - fix compiler warning  [Karel Zak]
   - fix memory leak [clang-analyzer]  [Sami Kerola]
uuidd:
   - add missing initializer [clang-analyzer]  [Karel Zak]

