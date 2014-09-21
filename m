Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaIUL6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 07:58:55 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37595 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaIUL6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 07:58:53 -0400
Message-ID: <541EBD79.706@gmail.com>
Date: Sun, 21 Sep 2014 13:58:49 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.73 is released
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.73 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.73

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/09/man-pages-373-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.73 ====================

New and rewritten pages
-----------------------

namespaces.7
    Michael Kerrisk  [Eric W. Biederman]
        New page providing overview of Linux namespaces

pid_namespaces.7
    Michael Kerrisk  [Eric W. Biederman, Vasily Kulikov, Rob Landley,
                      Serge Hallyn]
        New page describing PID namespaces

user_namespaces.7
    Michael Kerrisk  [Eric W. Biederman, Andy Lutomirski, Serge Hallyn]
        New page describing user namespaces.


Newly documented interfaces in existing pages
---------------------------------------------

clone.2
    Eric W. Biederman  [Michael Kerrisk]
        Document CLONE_NEWUSER for creating a new user namespace

setns.2
    Eric W. Biederman, Michael Kerrisk
        Document the PID, user, and mount namespace support
            Document CLONE_NEWPID, CLONE_NEWUSER, and CLONE_NEWNS flags.

unshare.2
    Michael Kerrisk  [Eric W. Biederman]
        Document CLONE_NEWPID
    Michael Kerrisk  [Eric W. Biederman]
        Document CLONE_NEWUSER
    Michael Kerrisk
        Document CLONE_THREAD, CLONE_SIGHAND, and CLONE_VM


Changes to individual pages
---------------------------

clone.2
    Michael Kerrisk
        Move some CLONE_NEWNET text to namespaces.7
    Michael Kerrisk
        Move some CLONE_NEWUTS text 2 to namespaces.7
    Michael Kerrisk
        Move some CLONE_NEWIPC text to namespaces.7
    Michael Kerrisk
        Reword discussion of CLONE_NEWNS, removing text also in namespaces(7)
    Michael Kerrisk
        Standardize text on CLONE_NEW* flags and CAP_SYS_ADMIN
    Michael Kerrisk
        EINVAL if (CLONE_NEWUSER|CLONE_NEWPID) && (CLONE_THREAD|CLONE_PARENT)
    Michael Kerrisk
        Add more detail on the meaning of CLONE_SYSVSEM

mount.2
    Eric W. Biederman
        Clarify use of 'mountflags' and 'data' for MS_REMOUNT

reboot.2
    Michael Kerrisk  [Justin Cormack, Eric W. Biederman]
        Document effect of reboot() inside PID namespaces

seteuid.2
setgid.2
setresuid.2
setreuid.2
setuid.2
    Michael Kerrisk
        EINVAL can occur if UID/GID is not valid in caller's user namespace

setns.2
    Michael Kerrisk  [Eric W. Biederman]
        Clarify capabilities required for reassociating with a mount namespace
    Michael Kerrisk
        Specify kernel version on each CLONE_NEW* flag
            And remove text on flags from VERSIONS.

unshare.2
    Michael Kerrisk
        Add an example program
    Michael Kerrisk
        Clarify semantics of CLONE_SYSVSEM
    Michael Kerrisk
        CLONE_SYSVSEM does not require CAP_SYS_ADMIN
    Michael Kerrisk
        Note flags implied by CLONE_THREAD and CLONE_VM

capabilities.7
    Michael Kerrisk
        Refer reader to user_namespaces(7) for a discussion of capabilities
    Michael Kerrisk
        Document CAP_SETUID and CAP_SETGID for user namespace mappings
    Michael Kerrisk
        setns() needs CAP_SYS_ADMIN in the *target* namespace
    Michael Kerrisk
        Since Linux 3.8, user namespaces no longer require CAP_SYS_ADMIN

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
