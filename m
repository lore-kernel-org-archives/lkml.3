Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaJFSfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:35:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46951 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaJFSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:35:47 -0400
Message-ID: <5432E100.4080700@gmail.com>
Date: Mon, 06 Oct 2014 20:35:44 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.74 is released
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.74 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.74

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/10/man-pages-374-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.74 ====================

Released: 2014-10-03, Munich


New and rewritten pages
-----------------------

pldd.1
    Michael Kerrisk
        New page for pldd(1) command added to glibc in version 2.15

cp1252.7
    Marko Myllynen
        New page documenting CP 1252
            CP 1252 is probably one of the most used Windows Code Pages so
            let's add a page for it alongside with the already provided
            CP 1251 page.

            Table generated from /usr/share/i18n/charmaps/CP1252.


Newly documented interfaces in existing pages
---------------------------------------------

mq_overview.7
    Michael Kerrisk
        Document /proc/sys/fs/mqueue/msgsize_default
    Michael Kerrisk
        Document /proc/sys/fs/mqueue/msg_default


Changes to individual pages
---------------------------

fanotify_init.2
    Heinrich Schuchardt
        BUGS: O_CLOEXEC is ignored
    Michael Kerrisk  [Heinrich Schuchardt]
        The 'event_f_flags' failure to check invalid flags was fixed in 3.15

fanotify_mark.2
    Michael Kerrisk
        Note that various bugs were fixed in Linux 3.16

getrlimit.2
    Michael Kerrisk  [Doug Ledford]
        Since Linux 3.5, the accounting formula for RLIMIT_MSGQUEUE has changed

shmget.2
    Manfred Spraul  [Michael Kerrisk, Davidlohr Bueso]
        Update for increase of SHMALL and SHMMAX
            The default values of SHMALL and SHMMAX have been increased.

proc.5
    Elie De Brauwer
        Document /proc/buddyinfo
            This patch adds a short description about the contents of
            /proc/buddyinfo and how this file can be used to assist
            in checking for memory fragmentation issues.

mq_overview.7
    Michael Kerrisk
        Update queues_max details for Linux 3.14
            And in general rework the text a little.
    Michael Kerrisk
        Update discussion of HARD_MSGMAX
            The limit has changed in 2.6.33 and then again in 3.5.
    Michael Kerrisk  [Arto Bendiken]
        Update details for 'queues_max' limit
            Things changed in Linux 3.5.
            See https://bugs.launchpad.net/bugs/1155695
    Michael Kerrisk
        Update details on defaults and ceiling for 'msgsize_max' limit


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
