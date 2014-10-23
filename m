Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaJWMxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:53:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52626 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaJWMxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:53:31 -0400
Date: Thu, 23 Oct 2014 14:53:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: dmitry.torokhov@gmail.com, sre@kernel.org, B38611@freescale.com,
        pali.rohar@gmail.com, aaro.koskinen@iki.fi, jg1.han@samsung.com,
        linux-input@vger.kernel.org
Subject: 3.18.rc1: compile failure in tsc2005.c
Message-ID: <20141023125325.GB30572@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I get this. Before I start patching it, perhaps someone has fixed it
already?

								Pavel

  CC      drivers/input/touchscreen/tsc2005.o
drivers/input/touchscreen/tsc2005.c: In function
'tsc2005_disable_store':
drivers/input/touchscreen/tsc2005.c:406:2: error: implicit declaration
of function 'strict_strtoul' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
scripts/Makefile.build:257: recipe for target
'drivers/input/touchscreen/tsc2005.o' failed
make[3]: *** [drivers/input/touchscreen/tsc2005.o] Error 1
scripts/Makefile.build:402: recipe for target
'drivers/input/touchscreen' failed
make[2]: *** [drivers/input/touchscreen] Error 2
scripts/Makefile.build:402: recipe for target 'drivers/input' failed
make[1]: *** [drivers/input] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      net/core/request_sock.o


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
