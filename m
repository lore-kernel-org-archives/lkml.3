Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3HZGIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 02:08:05 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:51977 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3HZGID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 02:08:03 -0400
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 02:08:03 EDT
Message-ID: <521AED72.8050105@xs4all.nl>
Date: Mon, 26 Aug 2013 07:53:54 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am stuck with a weird keyboard related issue:
Since a few weeks I see loads of ^@^@^@^@^@^@ appear on the text console
while the PC_speaker beeps when this box is in runlevel 3.
When xorg is running the ^@^@^@ stream stops, as does the beeping, but I
can notice that selecting text, scrolling xterminals with the mouse are
interrupted by these characters appearing. (but not printing)

Removing/replacing the ps/2 keyboard does not help.
Rebooting does help for a while.

The hardware is a Gigabyte F2A85X-UP4, BIOS F5a 04/30/2013.
I replaced the board last weekend by a brand new F2A85X-UP4 with same
BIOS F5a but the problem persists.

What could this be?
Is it really a software issue?
If so: how could I help fix this?

Kind regards,
Udo
