Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab3GPQ0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:26:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62152 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab3GPQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <51E5705B.3070705@nod.at>
References: <CALkWK0k2BsoxwMLHSWmmrFXkvMBiWDG1b0NXrfR6i95=tFPMXw@mail.gmail.com>
 <51E56DCB.3040108@nod.at> <CALkWK0kFJnDvsPy1HRzut7bxwXhLRQ0qivvy861S77Q6bhjrCQ@mail.gmail.com>
 <51E5705B.3070705@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 21:56:09 +0530
Message-ID: <CALkWK0kibE4ZcwEPOGU2Rmt1ZfODqQ0SoN2RmhEp-BiftsF0Uw@mail.gmail.com>
Subject: Re: [QUERY] User-Mode Linux and /dev/tty*
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> UML does not have virtual consoles.

Then why do I see this on my UML box?

# ls /dev/tty* | wc -l
113

Why is it creating unusable devices?  Is drivers/tty.c responsible for
this?  What is it exactly?

> I'm not running HEAD, but opensuse 12.3 (with systemd) works on UML.

Also, what's with all the

   xterm_open : run_helper failed, errno = 2

messages?  (I installed xterm, but it wasn't very enlightening)
How is drivers/xterm.c supposed to work?  And what is mconsole?
