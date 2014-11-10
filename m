Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaKJOWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:22:19 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:34408 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaKJOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:22:18 -0500
Date: Mon, 10 Nov 2014 14:22:00 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Martin Tournoij <martin@arp242.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] The SIGINFO signal from BSD
Message-ID: <20141110142200.676b5d04@alan.etchedpixels.co.uk>
In-Reply-To: <20141105201404.GH27083@thunk.org>
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
	<545A7B00.1040309@gmail.com>
	<20141105201404.GH27083@thunk.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> wouldn't be accepted.  (BTW, if you're going to do this, note that ^T
> could be remapped to any control character via stty; so to do this we
> would need to define an extra index in c_cc[] array in the struct
> termios.)

We have 19 entries in the array and no platforms that byte pack so that
would actually be doable I think.

I'm really dubious about its value in the Linux world. You could do far
better teaching the GUI desktop to walk the process tree of clients and
dump the window owners process subtrees in a nice pop up window.

PS: Austin - SIGPWR was used on the System 5 boxes I used to indicate
power had been *restored* not lost. The primary usage was in curses and
termios using apps so that when the power came back on they would redraw
the screens on all the terminals.

You have to think back to a world of a generator/battery backed servers
and non battery backed terminals for that to make sense.

Alan
