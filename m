Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3GAIxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:53:10 -0400
Received: from ozlabs.org ([203.10.76.45]:48465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab3GAIxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:53:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ryan Bourgeois <bluedragonx@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "lkml" <linux-kernel@vger.kernel.org>
Subject: [bugzilla-daemon@bugzilla.kernel.org] [Bug 60241] New: On apple aluminium keyboard by default function keys work as multimedia keys.
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 01 Jul 2013 12:58:39 +0930
Message-ID: <87hagfrmag.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing people who git history says might have a clue...

Cheers,
Rusty.

From: bugzilla-daemon@bugzilla.kernel.org
To: rusty@rustcorp.com.au
Subject: [Bug 60241] New: On apple aluminium keyboard by default function
 keys work as multimedia keys.
Date: Sun, 30 Jun 2013 11:26:50 +0000 (UTC)

https://bugzilla.kernel.org/show_bug.cgi?id=60241

           Summary: On apple aluminium keyboard by default function keys
                    work as multimedia keys.
           Product: Other
           Version: 2.5
    Kernel Version: 3.9.8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Modules
        AssignedTo: other_modules@kernel-bugs.osdl.org
        ReportedBy: mikhail.v.gavrilov@gmail.com
        Regression: No


Please set hid_apple.fnmode to 2 by default

I don't know situation when on the Linux will more useful multimedia keys
instead functional. On whole internet on all forums for all Linux distribution
gives one advice to set 'hid_apple.fnmode=2' option in GRUB_CMDLINE_LINUX. Why
not this change doing in kernel by default?

This will make Linux easier for owners of apple aluminium keyboard.

Thanks.
