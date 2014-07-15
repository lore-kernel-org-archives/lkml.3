Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaGOVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:15:22 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:65268 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaGOVPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:15:20 -0400
MIME-Version: 1.0
Date: Tue, 15 Jul 2014 14:15:18 -0700
Message-ID: <CA+r1Zhg9wwv6qUcRMWNBadE=dWFjbb45J+SwRpV7xg8AmgSEpw@mail.gmail.com>
Subject: make mandocs fails with next-20140715
From: Jim Davis <jim.epost@gmail.com>
To: sfr@canb.auug.org.au, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, rdunlap@infradead.org,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jim@krebstar:~/linux2$ make mandocs
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/docproc
  DOCPROC Documentation/DocBook/z8530book.xml
  MAN     Documentation/DocBook/z8530book.9
Warn: AUTHOR sect.: no personblurb|contrib for Alan Cox

[... ]

Note: Writing spans_boundary.9
  DOCPROC Documentation/DocBook/device-drivers.xml
docproc: .//kernel/timer.c: No such file or directory
make[1]: *** [Documentation/DocBook/device-drivers.xml] Error 1
make: *** [mandocs] Error 2
