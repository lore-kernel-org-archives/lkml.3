Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaJXNUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:20:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbaJXNT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:19:59 -0400
Date: Fri, 24 Oct 2014 15:19:55 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.25.2
Message-ID: <20141024131955.GE10134@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The util-linux stable release v2.25.2 is available at
 
   ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.25
    
Feedback and bug reports, as always, are welcomed.
     
       Karel


Util-linux 2.25.2 Release Notes
===============================

agetty:
   - fixing FTBFS on !linux (Debian util-linux 2.20.1-1.2)  [Christoph Egger]
blkdiscard:
   - fix err->errx()  [Karel Zak]
   - fix underflow when offset is greater than device size  [Raphael S. Carvalho]
blkid:
   - remove extra trailing spaces in output  [Karel Zak]
build-sys:
   - build libmount everywhere  [Andreas Henriksson]
   - check for libtoolize rather than libtool  [Helmut Grohne]
   - use -lutil for BSD only  [Karel Zak]
cal:
   - `color` option documentation should match actual behaviour  [Eugene Yunak]
cfdisk:
   - don't modify ncurses LINES and COLS  [Karel Zak]
docs:
   - fix mess in Release notes  [Karel Zak]
   - remove obsolete READMEs for (s)fdisk  [Karel Zak]
   - update AUTHORS file  [Karel Zak]
fdisk:
   - add section about sizes to the man page  [Karel Zak]
flock:
   - zero timeout is valid  [Karel Zak]
hexdump:
   - remove deprecation message  [Sami Kerola]
hwclock:
   - use fabs() instead abs() when argument is double  [Sami Kerola]
ipcrm:
   - add hacks to avoid FTBFS  [Andreas Henriksson]
ipcs:
   - remaining kFreeBSD hackery for building.  [Aurelien Jarno]
last:
   - make is_phantom() when kernel config does not include audit support  [Sami Kerola]
lib/blkdev:
   - report correct disk size on GNU/kFreeBSD. Thanks Tuco.  [Robert Millan]
libblkid:
   - zeroize errno on blkid_probe_get_buffer() success  [Karel Zak]
libfdisk:
   - fix add_logical() assert  [Karel Zak]
   - make yes/no dialogs more robust  [Karel Zak]
libmount:
   - don't return root if path contains // or ending /  [Søren Holm]
   - fix mnt_is_readonly() #ifdef  [Karel Zak]
   - hide details about failed search in fstab/mtab  [Karel Zak]
   - only include context on linux  [Andreas Henriksson]
   - only invoke loopcxt on linux  [Andreas Henriksson]
linfdisk:
   - cleanup fsync usage  [Karel Zak]
logger:
   - gettimeofday needs <sys/time.h>  [Andreas Henriksson]
losetup:
   - improve man page -D docs  [Karel Zak]
lsblk:
   - add notes about udev to the man page  [Karel Zak]
lscpu:
   - fix cppcheck warnings  [Boris Egorov]
lslogins:
   - cleanup after error [coverity scan]  [Karel Zak]
   - free after error [coverity scan]  [Karel Zak]
mkfs.minix:
   - fix couple compiler warnings  [Sami Kerola]
mount:
   - don't ignore mtab for --bind -o remount  [Karel Zak]
   - improve --move docs  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update es.po (from translationproject.org)  [Antonio Ceballos Roa]
script:
   - may be hangs  [Andreas Henriksson]
setterm:
   - fix dubious one-bit signed bitfield [smatch scan]  [Sami Kerola]
su:
   - print proper core dump message when killed  [pcpa]
terminal-colors.d:
   - fix filter by name  [Karel Zak]
tests:
   - fix the ipcs test for shmall being too big to show  [Karel Zak]
umount:
   - read mountinfo if --detach-loop given  [Robert Schiele]
whereis:
   - cleanup debug stuff, fix argv[] usage  [Karel Zak]
   - reset search mask more carefully  [Karel Zak]
