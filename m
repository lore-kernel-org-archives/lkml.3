Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3BCXEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:04:11 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:50970 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3BCXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:04:09 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 4 Feb 2013 00:03:48 +0100
Message-ID: <CAKgNAkjXsA=ua+px05qNDWmtH=5OCZbpOAFyJCXF76wYSjFUmg@mail.gmail.com>
Subject: man-pages-3.46 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.46 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.46

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2013/02/man-pages-346-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.46 ====================


New and rewritten pages
-----------------------

kcmp.2
    Cyrill Gorcunov, Michael Kerrisk
        New page for kcmp(2)


Newly documented interfaces in existing pages
---------------------------------------------

init_module.2
    Michael Kerrisk  [Kees Cook, Rusty Russell, Lucas De Marchi]
        Document finit_module(2)
    Rusty Russell  [Lucas De Marchi, Kees Cook]
        Document finit_module() 'flags' argument
            Document MODULE_INIT_IGNORE_MODVERSIONS and
            MODULE_INIT_IGNORE_VERMAGIC. (Some edits by mtk.)


Changes to individual pages
---------------------------

clone.2
    Michael Kerrisk
        CLONE_NEWIPC governs mechanisms that don't have filesystem pathnames
    Michael Kerrisk
        CLONE_NEWIPC doesn't mount the POSIX MQ file system
    Michael Kerrisk
        Add an example program (CLONE_NEWUTS)

link.2
prctl.2
    Kees Cook
        Document PR_SET_PTRACER
            Document the Yama LSM's prctl handler that allows processes to
            declare ptrace restriction exception relationships via
            PR_SET_PTRACER.
    Michael Kerrisk
        Document PR_GET_TID_ADDRESS

ptrace.2
    Michael Kerrisk
        Document PTRACE_O_EXITKILL

recvmmsg.2
    Elie De Brauwer
        Add an example program

setns.2
    Michael Kerrisk
        Add example program

core.5
proc.5
    Kees Cook
        Clarify suid_dumpable versus core_pattern
            In Linux 3.6, additional requirements were placed on core_pattern
            when suid_dumpable is set to 2. Document this and include commit
            references.

proc.5
    Justin Lebar
        statm's "shared" field refers to pages backed by files
    Kees Cook
        Document /proc/sys/kernel/dmesg_restrict
    Kees Cook
        Linux 3.4 changed permissions needed to change kptr_restrict
    Michael Kerrisk
        Document /proc/stat "cpu" "nice_guest" field
            Info taken from commit ce0e7b28fb75cb003cfc8d0238613aaf1c55e797
    Michael Kerrisk  [Peter Lekeynstein]
        Document /prod/[pid]/oom_score_adj
            Text taken directly from Documentation/filesystems/proc.txt,
            with some light editing.

capabilities.7
    Michael Kerrisk
        Add kcmp(2) under CAP_SYS_PTRACE

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
