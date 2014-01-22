Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaAVP46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:56:58 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55484 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAVP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:56:53 -0500
Message-ID: <52DFEA40.8020305@gmail.com>
Date: Wed, 22 Jan 2014 16:56:48 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com, Andrew Josey <ajosey@opengroup.org>,
        Felix Janda <felix.janda@posteo.de>
Subject: IEEE/TOG grant permission to distribute POSIX.1-2013 man pages for
 Linux
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

The manual pages produced by the Linux man-pages project attempt
to document deviations between Linux behavior and the POSIX.1 standard.
However, the pages are no substitute for the standard itself.

In 2004, the IEEE and The Open Group decided to grant permission to the 
Linux man-pages project to distribute parts of the then-current version
of POSIX.1 in manual page format. That decision provided an extremely
valuable resource for Linux programmers who wanted to write applications
that are portable across UNIX systems. Evidence of that value has been
demonstrated by regular requests in the last few years that the project
should update its copy of the POSIX manual pages to the latest
version provided by The Austin Group (the umbrella group that works
on development of the POSIX.1 standard).

We are pleased to announce that, once again, the IEEE and The Open Group
have kindly granted us permission to distribute extracts from the 
latest version of the POSIX.1 standard:

    IEEE Std 1003.1, 2013 Edition, Standard for Information 
    Technology--Portable Operating System Interface (POSIX), 
    The Open Group Base Specifications Issue 7, 
    Copyright (C) 2013 by the Institute of Electrical and 
    Electronics Engineers, Inc and The Open Group.

(For those curious about the "2013" designation, this is
POSIX.1-2008 with the 2013 Technical Corrigendum 1 applied.) 

Thanks to some excellent scripting work by Felix Janda, the source 
files supplied by IEEE and The Open Group have been cleanly converted 
to  "man" format. The result is that portions of the standard are now
made available for easy reference  as (1139!) manual pages. Those 
pages are divided into three sections:

    Section 0p = POSIX headers (specifications for header files)
    Section 1p = POSIX utilities (i.e., specifications shell commands)
    Section 3p = POSIX functions (specifications for functions)

Tarballs containing the pages can be found at
https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-2013-a.tar.gz
and
https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-2013-a.tar.xz

Please note that all pages carry the following disclaimer:

    In the event of any discrepancy between this version and the original 
    IEEE and The Open Group Standard, the original IEEE and The Open 
    Group Standard is the referee document. The original Standard can 
    be obtained online at http://www.unix.org/online.html .

    Any typographical or formatting errors that appear in this page are
    most likely to have been introduced during the conversion of the 
    source files to man page format. To report such errors, see 
    https://www.kernel.org/doc/man-pages/reporting_bugs.html .

Thanks,

Michael

--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
