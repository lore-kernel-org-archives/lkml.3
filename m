Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3LJKwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:52:35 -0500
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:53293
	"EHLO qmta01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab3LJKwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:52:33 -0500
To: mpatocka@redhat.com, peter@hurleysoftware.com
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312092103290.11182@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: edbrowse/3.4.9
Subject: [PATCH 3.12] Broken terminal due to echo bufferring
Date: Tue, 10 Dec 2013 05:52:32 -0500
Message-ID: <20131110055232.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a followup to my last post.
You don't need to compile the write("prompt>") program to see the bug.
Just edit a modest text file with /bin/ed, which runs in cooked mode.
As soon as the file comes up, hit ^c.
Lots of old stuff comes spewing out.
Eventually the tty is back and you can edit the file as usual, or quit.

Karl Dahlke
