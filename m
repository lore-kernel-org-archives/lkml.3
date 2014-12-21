Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaLUOhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:37:45 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:55415 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLUOhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:37:43 -0500
X-Auth-Info: eVOWLB/NZrso7o/xXqisVu4HZ57n2oVhpv07fwq5Xqmu5XYUGfvObOJfhctVOJon
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Drysdale <drysdale@google.com>, Shuah Khan <shuahkh@osg.samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH selftest fails!] m68k: Wire up execveat
References: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg>
X-Yow: Pardon me, but do you know what it means to be TRULY ONE
 with your BOOTH!
Date: Sun, 21 Dec 2014 15:37:36 +0100
In-Reply-To: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg> (Geert
	Uytterhoeven's message of "Sun, 21 Dec 2014 12:02:11 +0100 (CET)")
Message-ID: <874msp3w7j.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Check success of execveat(5, 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [FAIL] (child 792 exited with 126 not 127)

POSIX says (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_08_02):

    If a command is not found, the exit status shall be 127. If the
    command name is found, but it is not an executable utility, the exit
    status shall be 126.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
