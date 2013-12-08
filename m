Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3LHG2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:28:15 -0500
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:54596
	"EHLO qmta08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab3LHG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:28:13 -0500
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
References: <20131107184607.eklhad@comcast.net> <20131208053621.GA6445@kroah.com>
User-Agent: edbrowse/3.4.9
Subject: Bug in tty cooked mode kernel 3.12.3
Date: Sun, 08 Dec 2013 01:16:09 -0500
Message-ID: <20131108011609.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per your direction, I applied Peters patch to n_tty.c,
which looked like it was in the ballpark, echoing newline etc,
but it did not fix the problem.
It is still reproducible on my system as below.

> Come up in run level 3, command line mode,
> and bring up two consoles with bash in cooked mode.
> Set a simple prompt like this.
>
> PS1='$ '
>
> Switch to console 2 via alt-f2.
> Hit return.
> The cursor should drop to a new line then give you the $ prompt.
> But it puts the $ prompt next too the old one, then drops down
> to a blank line.
> The $ prompt and the crlf are out of sequence.
> Hit return a few more times and it will straighten itself out.
> Then switch back to console 1 alt-f1
> Hit return and the same bug,
> $ $
>
> hit return a few more times to straighten it out.
> Switch back to console 2 and the same problem.

Thank you for your quick reply,and the patch to try.
I'm afraid however this is still an unsolved problem.
Realize that it pops up rarely and randomly in just about any cooked program;
I chose the console switch example because it most reliably reproduces the bug.

Thank you.

Karl Dahlke
