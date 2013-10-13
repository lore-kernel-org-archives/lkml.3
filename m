Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3JMXxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 19:53:21 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:50615 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3JMXxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 19:53:20 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Oct 2013 19:53:20 EDT
Message-ID: <1381707976.3914.22.camel@heisenberg.scientia.net>
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Cc: Chris Eastwood <chris2027@gmail.com>, gregkh@linuxfoundation.org,
        linux@roeck-us.net
Date: Mon, 14 Oct 2013 01:46:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Guenter and Chris.

Coming back to the stuff discussed previously[0].

Chris Eastwood has made most of these (i.e. LEDs and buttons, the
buzzers may work on at least some of the devices via some other serial
device) working (AFAIU based on the previously mentioned code at
Github[1]), he told me in several iterations of private mail.

I'm not sure now, whether anything based on this code would be
appropriate for the mainline kernel, since Guenter mentioned he'd prefer
a mfd core driver for all that... OTOH, the later may probably never
happen, and Chris' work seems to already do the job.

I don't know however, whether he needs to patch any other places in the
kernel, but I'm sure he can show his work (and ask questions) better
than I, thereby inviting him to do so.
Greg you had mentioned before that you might be able to spend some time
on this, so if you could help Chris, that would be great.


Cheers,
Chris.

[0] http://thread.gmane.org/gmane.linux.kernel/1508763/focus=1512903
[1] https://github.com/tomtastic/qnap-gpio/

PS: Sorry for having lost the message threading.

