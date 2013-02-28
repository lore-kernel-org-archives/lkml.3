Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3B1LVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:21:00 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59024 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3B1LU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:20:59 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 28 Feb 2013 12:20:38 +0100
Message-ID: <CAKgNAkgvtk_WpP7NFrPaPtEsCq2EM=_O5QBBNdOOr9uV02Uasg@mail.gmail.com>
Subject: man-pages-3.47 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.47 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.47

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2013/02/man-pages-347-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.47 ====================


New and rewritten pages
-----------------------

perf_event_open.2
    Vincent Weaver
        New page documenting perf_event_open(2)

pthread_setname_np.3
    Chandan Apsangi, Michael Kerrisk
        New page for pthread_setname_np(3) and pthread_getname_np(3)

sln.8
    Michael Kerrisk  [Peter Schiffer]
        New page documenting the 'sln' command provided by glibc
            Inspired by a Red Hat downstream page, but with rather
            more detail.


Newly documented interfaces in existing pages
---------------------------------------------

prctl.2
    Michael Kerrisk  [Shawn Landden, Lennart Poettering]
        Document PR_SET_CHILD_SUBREAPER and PR_GET_CHILD_SUBREAPER

ip.7
    Radek Pazdera
        Add source-specific multicast sockopts
            This patch adds documentation of several source-specific multicast
            socket options that were added to kernel with implementation
            of IGMPv3 in 2.5.68.

            The following socket options were added:
              IP_ADD_SOURCE_MEMBERSHIP
              IP_DROP_SOURCE_MEMBERSHIP
              IP_BLOCK_SOURCE
              IP_UNBLOCK_SOURCE
              IP_MSFILTER


Changes to individual pages
---------------------------

proc.5
    Michael Kerrisk
        Document /proc/profile
