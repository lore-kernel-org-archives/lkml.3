Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaJPJTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:19:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49645 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaJPJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:19:22 -0400
Message-ID: <543F8D97.70605@gmail.com>
Date: Thu, 16 Oct 2014 11:19:19 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.75 is released
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.75 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.75

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/10/man-pages-375-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.75 ====================

New and rewritten pages
-----------------------

pthread_rwlockattr_setkind_np.3
    Robert Schweikert  [Michael Kerrisk]
        New page documenting pthread_rwlockattr_[sg]etkind_np(3)
            Documents pthread_rwlockattr_setkind_np(3) and
            pthread_rwlockattr_getkind_np(3).


Changes to individual pages
---------------------------

readv.2
    Michael Kerrisk
        The raw preadv() and pwritev() syscalls split 'offset' into 2 arguments

signal.7
    Michael Kerrisk
        pthread_mutex_lock() and pthread_cond_wait() are restartable
            pthread_mutex_lock(, pthread_cond_wait(), and related APIs are
            automatically restarted if interrupted by a signal handler.

unix.7
    Michael Kerrisk  [Carlos O'Donell, David Miller, Tetsuo Handa]
        Various additions and rewordings
            Notable changes:
            * Clarify some details for pathname sockets.
            * Add some advice on portably coding with pathname sockets.
            * Note the "buggy" behavior for pathname sockets when
              the supplied pathname is 108 bytes (after a report by
              Tetsuo Handa).


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
