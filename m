Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaFPEMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:12:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45977 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaFPEMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:12:19 -0400
Message-ID: <539DFA40.5010402@gmail.com>
Date: Sun, 15 Jun 2014 21:55:44 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.69 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces his 150th release
as project maintainer:

    man-pages-3.69 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.69

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/06/man-pages-369-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.69 ====================


New and rewritten pages
-----------------------

iconv.1
    Marko Myllynen  [Michael Kerrisk]
        New page for the iconv(1) command

iconvconfig.8
    Marko Myllynen
        New page for iconvconfig(8)


Newly documented interfaces in existing pages
---------------------------------------------

fcntl.2
    Jeff Layton, Michael Kerrisk
        Document open file description locks
            As provided by the fcntl() operations F_OFD_SETLK,
            F_OFD_SETLKW, and F_OFD_GETLK


Changes to individual pages
---------------------------

execve.2
    Michael Kerrisk  [NeilBrown]
        Before kernel 2.6.0, RLIMIT_NPROC had no effect for set*uid()
    Michael Kerrisk  [Vasiliy Kulikov]
        RLIMIT_NPROC is checked only if preceded by set*uid()
    Michael Kerrisk  [Vasiliy Kulikov, NeilBrown, KOSAKI Motohiro]
        Document EAGAIN error
            See also https://bugzilla.kernel.org/show_bug.cgi?id=42704

fcntl.2
    Michael Kerrisk
        Detail the limitations of traditional (process-associated) locks
    Michael Kerrisk  [Jeff Layton]
        Add notes on F_SETLKW deadlock detection and its limitations
    Michael Kerrisk  [Jeff Layton]
        Reword discussion of mandatory lock bug a little
            Jeff Layton confirmed that the bug remains even in modern kernels.
    Michael Kerrisk  [NeilBrown]
        Note treatment of locks when an NFS client loses contact with the server

flock.2
    Michael Kerrisk
        In some modern BSDs, fcntl() and flock() locks do interact
            So, reword and extend the discussion of this topic in NOTES.
    Michael Kerrisk  [NeilBrown]
        Add more details on NFS, including Linux 2.6.37 changes

open.2
    Michael Kerrisk
        Rework and extend the discussion of open file descriptions

remap_file_pages.2
    Michael Kerrisk  [Kirill A. Shutemov]
        Note that remap_file_pages() is deprecated

seteuid.2
    Michael Kerrisk
        seteuid() and setegid() are implemented as library functions
    Michael Kerrisk
        Error checking should always be performed, even when caller is UID 0

setresuid.2
    Michael Kerrisk
        Document EAGAIN error that can occur after kernel alloc_uid() failure
    Michael Kerrisk
        Since Linux 3.1, the EAGAIN case for RLIMIT_NPROC no longer occurs
    Michael Kerrisk
        Error checking should always be performed, even when caller is UID 0

setreuid.2
    Michael Kerrisk
        Document EAGAIN error that can occur after kernel alloc_uid() failure
    Michael Kerrisk
        Error checking should always be performed, even when caller is UID 0
    Michael Kerrisk
        Add EAGAIN error for hitting RLIMIT_NPROC limit
    Michael Kerrisk
        Since Linux 3.1, the EAGAIN case for RLIMIT_NPROC no longer occurs

setuid.2
    Michael Kerrisk
        Document EAGAIN error that can occur after kernel alloc_uid() failure
    Michael Kerrisk
        Correct the description of the EAGAIN error
    Michael Kerrisk
        Error checking should always be performed, even when caller is UID 0
    Michael Kerrisk
        Since Linux 3.1, the EAGAIN case for RLIMIT_NPROC no longer occurs



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
