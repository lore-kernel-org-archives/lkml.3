Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaCLIx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:53:57 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61894 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCLIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:53:53 -0400
Message-ID: <5320209D.4060805@gmail.com>
Date: Wed, 12 Mar 2014 09:53:49 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.62 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.62 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.62

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/03/man-pages-362-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.62 ====================

New and rewritten pages
-----------------------

locale.1
    Michael Kerrisk [review from Mike Frysinger]
        New page describing locale(1)


Newly documented interfaces in existing pages
---------------------------------------------

locale.5
    Michael Kerrisk
        Document LC_ADDRESS
    Michael Kerrisk
        Document LC_IDENTIFICATION
    Michael Kerrisk
        Document LC_MEASUREMENT
    Michael Kerrisk
        Document LC_NAME
    Michael Kerrisk
        Document LC_PAPER
    Michael Kerrisk
        Document LC_TELEPHONE


Changes to individual pages
---------------------------

stat.2
    Michael Kerrisk  [Marius Gaubas]
        Warn the reader that the 'stat' structure definition is not precise
            Padding fields aren't shown, and the order of fields varies
            somewhat across architectures.

feature_test_macros.7
    Michael Kerrisk
        _BSD_SOURCE and _SVID_SOURCE are deprecated in glibc 2.20


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
