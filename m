Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaCRQwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:52:22 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40311 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaCRQwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:52:21 -0400
Message-ID: <532879C0.7080507@gmail.com>
Date: Tue, 18 Mar 2014 17:52:16 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.63 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.63 - man pages for Linux

He also proudly announces that man-pages recently passed
10,000 commits since he took over as maintainer in 2004
(https://plus.google.com/u/0/+MichaelKerrisk/posts/SVH47FGnQCN ).


Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.63

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/03/man-pages-363-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.63 ====================

Released: 2014-03-18, Munich


New and rewritten pages
-----------------------

duplocale.3
    Michael Kerrisk
        New page documenting duplocale(3)

newlocale.3
    Michael Kerrisk  [Mike Frysinger]
        New page documenting newlocale(3) and freelocale(3)

uselocale.3
    Michael Kerrisk
        New page documenting uselocale(3)


Newly documented interfaces in existing pages
---------------------------------------------

open.2
    Michael Kerrisk
        Document O_DSYNC and rewrite discussion of O_SYNC

proc.5
    Michael Kerrisk
        Document /proc/sys/kernel/random/uuid

locale.7
    Michael Kerrisk
        Document LC_ADDRESS
        Document LC_IDENTIFICATION
        Document LC_MEASUREMENT
        Document LC_NAME
        Document LC_PAPER
        Document LC_TELEPHONE


Changes to individual pages
---------------------------

readahead.2
    Phillip Susi  [Corrado Zoccolo, Gregory P. Smith, Zhu Yanhai, Michael Kerrisk, Christoph Hellwig]
        Don't claim the call blocks until all data has been read
            The readahead(2) man page was claiming that the call blocks until
            all data has been read into the cache.  This is incorrect.

            See https://bugzilla.kernel.org/show_bug.cgi?id=54271

fts.3
    Christoph Hellwig  [Michael Kerrisk]
        The fts(3) API does not work with LFS builds
            As pointed out during a recent discussion on libc-hacker the
            fts(3) APIs can't be used with large file offsets:

                https://sourceware.org/bugzilla/show_bug.cgi?id=15838

core.5
    Mike Frysinger  [Michael Kerrisk]
        Document core_pattern %d specifier
        Document %P core_pattern specifier

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
