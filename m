Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaBNPR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:17:58 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:62158 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaBNPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:17:57 -0500
Message-ID: <52FE33A0.6090702@gmail.com>
Date: Fri, 14 Feb 2014 16:17:52 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.58 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.58 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.58

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/02/man-pages-359-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.58 ====================

Released: 2014-02-11, Munich


Newly documented interfaces in existing pages
---------------------------------------------

pipe.2
    Michael Kerrisk
        Document the pipe2() O_DIRECT flag added in Linux 3.4

packet.7
    Daniel Borkmann
        Document PACKET_QDISC_BYPASS
            New in Linux 3.14.



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
