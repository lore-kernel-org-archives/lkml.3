Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3DYNsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:48:18 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:41892 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932267Ab3DYNsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:48:16 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Thu, 25 Apr 2013 15:48:10 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: Problem compiling firmware/yam/9600.bin in 3.8.8
Message-Id: <20130425154810.a296c8fd.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I just tried to compile a complete kernel 3.8.8 including firmwares. First I
linked /usr/include/linux to /usr/src/linux/include/linux. I think this is for
user-space compilations to use the right header files, correct?
Then I tried the kernel and this is what happened:

  IHEX    firmware/yam/9600.bin
In file included from /usr/include/bits/errno.h:24:0,
                 from /usr/include/errno.h:35,
                 from firmware/ihex2fw.c:15:
/usr/include/linux/errno.h:4:30: fatal error: uapi/linux/errno.h: No such file
or directory compilation terminated.
make[1]: *** [firmware/ihex2fw] Error 1
make: *** [modules] Error 2

/usr/include/uapi is empty, but
/usr/src/linux/include/uapi is not

Did I miss something or are there more links to make nowadays for a complete setup?

Please cc me in case ...

-- 
Regards,
Stephan
