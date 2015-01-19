Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbbASI1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:27:24 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:52796 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbbASI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:27:23 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2015 03:27:22 EST
Message-ID: <54BCBDD4.10102@physik.fu-berlin.de>
Date: Mon, 19 Jan 2015 09:18:28 +0100
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/recordmcount.pl: There is no -m32 option
 on Super-H
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: 92.200.23.186
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven!

>> The Super-H architecure seems to be without any maintainer.
>> Maybe Steven cares to pick this patch up. Dunno...

> Yeah, I remember when the SH maintainer left.

> I can pick it up. How urgent is it? Does it need to go in before the
> next merge window? And does it need to be tagged for stable?

I am one of the Debian porters of the SH port. Currently, the kernel
package fails to build from source on our automatic build machines
due to this bug. Here is the full build log where you can see it
fail with gcc-4.8:

>
http://buildd.debian-ports.org/status/fetch.php?pkg=linux&arch=sh4&ver=3.16.7-ckt4-1&stamp=1421425783

Since the SH port of Debian was long time poorly maintained, this
issue hasn't got any attention for quite a while which means the
most current kernel version we have at the moment on SH is 3.2.0
something. I asked Michael to submit this change on my behalf since
he has submitted kernel patches in the past.

Thus, it would be nice if this fix could be merged ASAP upstream
and included in all stable releases as well such that we get a
working up-to-date kernel on SH soon.

Thanks!
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
