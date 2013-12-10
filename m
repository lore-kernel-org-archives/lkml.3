Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3LJANb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:13:31 -0500
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:48952
	"EHLO qmta10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3LJAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:13:29 -0500
To: peter@hurleysoftware.com
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
References: <20131107184607.eklhad@comcast.net> <1386630367-4658-1-git-send-email-peter@hurleysoftware.com>
User-Agent: edbrowse/3.4.9
Subject: Bug in tty cooked mode kernel 3.12.3
Date: Mon, 09 Dec 2013 19:12:04 -0500
Message-ID: <20131109191204.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for the report, Karl.
> 
> Please test the patch below (requires
> commit 39434abd942c8e4b9c14c06a03b3245beaf8467f,
> 'n_tty: Fix missing newline echo').
> This should fix the 'newline output after the new prompt' problem.

Hey hey - you did it!
I did my console switch, which *always* revealed the bug,
and it is not there any more.
I've also spent a couple hours in cooked mode programs, like my editor,
and the lines are all correct.
I'll keep at it for a few days, but for now I'm going to say it's fixed.
Please push this into the next release, and perhaps backport
if possible; for those of us in cooked line mode
it was really an inconvenient bug.
Finally, my complements to you.
I read the code in n_tty.c and I don't understand any of it.
It's way beyond me.
Nice job, and thank you.


Karl Dahlke
