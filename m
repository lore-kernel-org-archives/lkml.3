Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaEXMYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:24:16 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:63448 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaEXMYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:24:15 -0400
Message-ID: <537EC987.4090809@gmail.com>
Date: Fri, 23 May 2014 06:07:35 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.67 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,


The Linux man-pages maintainer proudly announces:

    man-pages-3.67 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.67

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/05/man-pages-367-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.67 ====================


New and rewritten pages
-----------------------

sched_setattr.2
    Michael Kerrisk, Peter Zijlstra [Juri Lelli]
        New page describing sched_setattr(2) and sched_getattr(2)

system.3
    Michael Kerrisk
        Rewrote large parts of the page and added a number of details


Newly documented interfaces in existing pages
---------------------------------------------

sched.7
    Peter Zijlstra, Michael Kerrisk  [Juri Lelli]
        Document SCHED_DEADLINE


Changes to individual pages
---------------------------

bind.2
    Michael Kerrisk
        ERRORS: Add EADDRINUSE for ephemeral port range exhaustion

connect.2
    Michael Kerrisk  [William Morriss]
        ERRORS: Add EADDRNOTAVAIL for ephemeral port range exhaustion
            Verified from testing and the kernel source.
            See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=745775
    Michael Kerrisk
        Remove mention of ip_local_port_range under EAGAIN error

execve.2
    Michael Kerrisk  [Steven Stewart-Gallus]
        Note SIGKILL case when execve() fails beyond the point of no return

fanotify_init.2
    Heinrich Schuchardt [Michael Kerrisk]
        Document range of permitted flags for event_f_flags
            With a new patch included in the mm tree, event_f_flags is
            checked for allowable values.

recvmmsg.2
    Michael Kerrisk
        Describe timeout bug
            See https://bugzilla.kernel.org/show_bug.cgi?id=75371
            and http://thread.gmane.org/gmane.linux.man/5677

remap_file_pages.2
    Andy Lutomirski [Christoph Hellwig, Andy Lutomirski]
        remap_file_pages() has no benefit for real files
            Linux commit 3ee6dafc677a68e461a7ddafc94a580ebab80735 caused
            remap_file_pages to be emulated when used on real file.

proc.5
    Michael Kerrisk
        Document /proc/timer_stats

fanotify.7
    Heinrich Schuchardt  [Jan Kara]
        BUGS: error events can be lost when reading from fanotify FD

ip.7
    Michael Kerrisk
        Note cases where an ephemeral port is used
    Michael Kerrisk
        Remove BUGS text on glibc failing to declare in_pktinfo
    Michael Kerrisk
        Clarify 'ip_local_port_range' and mention the term "ephemeral ports"
    Michael Kerrisk
        Note some more details about assignment of ephemeral ports
    Michael Kerrisk
        BUGS: ephemeral port range exhaustion is diagnosed inconsistently
            Different system calls use different 'errno' values to diagnose
            exhaustion of the ephemeral port range.

sched.7
    Michael Kerrisk
        Document sched_rt_period_us and sched_rt_runtime_us /proc files
            And rework and relocate the text on dealing with runaway
            real-time processes.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
