Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbaE2TEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:04:34 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42504 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaE2TEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:04:31 -0400
Message-ID: <538784BA.3080807@gmail.com>
Date: Thu, 29 May 2014 21:04:26 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.68 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces his 150th release
as project maintainer:

    man-pages-3.68 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.68

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/05/man-pages-368-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.68 ====================

Released: 2014-05-28, Munich


New and rewritten pages
-----------------------

localedef.1
    Marko Myllynen, Richard Braakman, Alastair McKinstry, Lars Wirzenius
        New page for localedef(1)
            Add new page based on Debian localedef(1) page.


Changes to individual pages
---------------------------

locale.1
    Marko Myllynen
        Provide a step-by-step example of how to use a custom locale

fork.2
    Michael Kerrisk
        ERRORS: add pid_max and threads-max to EAGAIN
            And rewrite text to be the same as pthread_create(3).

proc.5
    Michael Kerrisk
        'pid_max' is a system-wide limit on number of threads and processes
            Since PIDs > /proc/sys/kernel/pid_max are not allocated, this
            file thus also imposes a system-wide limit on the number of
            threads and processes.

capabilities.7
    Michael Kerrisk
        CAP_SYS_ADMIN allows overriding RLIMIT_NPROC
    Michael Kerrisk
        CAP_SYS_PTRACE allows process_vm_readv(2) and process_vm_writev(2)

inotify.7
    Heinrich Schuchardt
        Add example program
            This example of the usage of the inotify API shows the
            usage of inotify_init1(2) and inotify_add_watch(2) as well
            as polling and reading from the inotify file descriptor.

locale.7
    Marko Myllynen [Michael Kerrisk]
        Document the LOCPATH environment variable

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
