Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaDTSsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 14:48:37 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:52829 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaDTSsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 14:48:35 -0400
Message-ID: <5354167F.6090401@gmail.com>
Date: Sun, 20 Apr 2014 20:48:31 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.65 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.65 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.65

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/04/man-pages-365-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.65 ====================

Released: 2014-04-20, Munich


Contributors
------------

The following people contributed patches/fixes or (noted in brackets
in the changelog below) reports, notes, and ideas that have been
incorporated in changes in this release:

Alex Thorlton <athorlton@sgi.com>
Ashish Sangwan <a.sangwan@samsung.com>
Christopher Covington <cov@codeaurora.org>
Christoph Hellwig <hch@infradead.org>
Craig McQueen <craig.mcqueen@beamcommunications.com>
Dave Chinner <david@fromorbit.com>
David Prévot <taffit@debian.org>
Greg Troxel <gdt@ir.bbn.com>
Matthew Dempsky <mdempsky@chromium.org>
Michael Kerrisk <mtk.manpages@gmail.com>
Mike Frysinger <vapier@gentoo.org>
Namjae Jeon <namjae.jeon@samsung.com>
Peng Haitao <penght@cn.fujitsu.com>
Petr Gajdos <pgajdos@suse.cz>
Richard Hansen <rhansen@bbn.com>
Simon Paillard <spaillard@debian.org>
Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Vince Weaver <vincent.weaver@maine.edu>
Yuri Kozlov <yuray@komyakino.ru>

Apologies if I missed anyone!


New and rewritten pages
-----------------------

inet_net_pton.3
    Michael Kerrisk
        New page describing inet_net_pton(3) and inet_net_ntop(3)


Newly documented interfaces in existing pages
---------------------------------------------

fallocate.2
    Michael Kerrisk, Namjae Jeon [Christoph Hellwig, Dave Chinner]
        Document FALLOC_FL_COLLAPSE_RANGE

prctl.2
    Michael Kerrisk  [Alex Thorlton]
        Document PR_SET_THP_DISABLE and PR_GET_THP_DISABLE

proc.5
    Michael Kerrisk
        Document /proc/[pid]/stack
    Michael Kerrisk
        Document /proc/[pid]/clear_refs


Changes to individual pages
---------------------------

fcntl.2
    Michael Kerrisk
        Note the race when O_CLOEXEC is used at same time as fork()+execve()

open.2
    Michael Kerrisk
        Add more detail on the race that O_CLOEXEC is designed to avoid


proc.5
    Petr Gajdos
        Improve /proc/[pid]/smaps entries description


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
