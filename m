Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3KUVLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:11:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60085 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751680Ab3KUVLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:11:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ben Widawsky <benjamin.widawsky@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Todd Previte <tprevite@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, bjackson0971@gmail.com
Subject: [Regression] Fwd: [Bug 64841] Linux hangs when suspending to disk
Date: Thu, 21 Nov 2013 22:24:03 +0100
Message-ID: <1669934.XNTsQyvtko@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart5299676.f5K04xX14b"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart5299676.f5K04xX14b
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi,

Unfortunately, your commit 828c79087cec (drm/i915: Disable GGTT PTEs on GEN6+
suspend) introduced a confirmed regression that seems to have made it into
stable.

Any chance to look into that?

Rafael

--nextPart5299676.f5K04xX14b
Content-Type: message/rfc822
Content-Disposition: inline; filename="forwarded message"
Content-Description: bugzilla-daemon@bugzilla.kernel.org: [Bug 64841] Linux hangs when suspending to disk

Return-Path: <bugzilla-daemon@bugzilla.kernel.org>
Received: from mail.kernel.org [198.145.19.201] (HELO mail.kernel.org) by serwer1319399.home.pl [79.96.170.134] with SMTP (IdeaSmtpServer v0.80) id 642e5487567a591a; Thu, 21 Nov 2013 17:09:29 +0100
Received: from mail.kernel.org (localhost [127.0.0.1]) by mail.kernel.org (Postfix) with ESMTP id 3E3F120791 for <rjw@rjwysocki.net>; Thu, 21 Nov 2013 16:09:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51]) by mail.kernel.org (Postfix) with ESMTP id 4F02A2078A for <rjw@rjwysocki.net>; Thu, 21 Nov 2013 16:09:18 +0000 (UTC)
Received: by bugzilla1.web.kernel.org (Postfix, from userid 48) id 4788A400C5; Thu, 21 Nov 2013 16:09:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: rjw@rjwysocki.net
Subject: [Bug 64841] Linux hangs when suspending to disk
Date: Thu, 21 Nov 2013 16:09:18 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Power Management
X-Bugzilla-Component: Hibernation/Suspend
X-Bugzilla-Version: 2.5
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjackson0971@gmail.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: rjw@rjwysocki.net
X-Bugzilla-Target-Milestone: ---
Message-ID: <bug-64841-76231-ZjstPiWo92@https.bugzilla.kernel.org/>
In-Reply-To: <bug-64841-76231@https.bugzilla.kernel.org/>
References: <bug-64841-76231@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,RP_MATCHES_RCVD, UNPARSEABLE_RELAY autolearn=unavailable version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on mail.kernel.org
X-Virus-Scanned: ClamAV using ClamSMTP

https://bugzilla.kernel.org/show_bug.cgi?id=64841

--- Comment #4 from Brad  Jackson <bjackson0971@gmail.com> ---
828c79087cec61eaf4c76bb32c222fbe35ac3930 is the first bad commit
commit 828c79087cec61eaf4c76bb32c222fbe35ac3930
Author: Ben Widawsky <benjamin.widawsky@intel.com>
Date:   Wed Oct 16 09:21:30 2013 -0700

    drm/i915: Disable GGTT PTEs on GEN6+ suspend

-- 
You are receiving this mail because:
You are the assignee for the bug.

--nextPart5299676.f5K04xX14b--

