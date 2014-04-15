Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaDOJJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:09:50 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38978 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:09:46 -0400
MIME-Version: 1.0
In-Reply-To: <bug-74121-2300@https.bugzilla.kernel.org/>
References: <bug-74121-2300@https.bugzilla.kernel.org/>
Date: Tue, 15 Apr 2014 14:39:45 +0530
Message-ID: <CAPdUM4MvYL9DbC1F2cVLEeOD+MM711Z7gMSKiRFwEH74T+Xujg@mail.gmail.com>
Subject: Re: [Bug 74121] New: [3.15-rc1] Exynos: Sandbox report fatal error
 "Unexpected 64bit argument detected"
From: Rahul Sharma <r.sh.open@gmail.com>
To: bugzilla-daemon@bugzilla.kernel.org
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From:  <bugzilla-daemon@bugzilla.kernel.org>
Date: 15 April 2014 14:32
Subject: [Bug 74121] New: [3.15-rc1] Exynos: Sandbox report fatal
error "Unexpected 64bit argument detected"
To: dri-devel@lists.freedesktop.org


https://bugzilla.kernel.org/show_bug.cgi?id=74121

            Bug ID: 74121
           Summary: [3.15-rc1] Exynos: Sandbox report fatal error
                    "Unexpected 64bit argument detected"
           Product: Drivers
           Version: 2.5
    Kernel Version: 3.15-rc1
          Hardware: Other
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Video(DRI - non Intel)
          Assignee: drivers_video-dri@kernel-bugs.osdl.org
          Reporter: r.sh.open@gmail.com
        Regression: No

Sandbox crashing with 3.15-rc1 stating below fatal error. This was working in
till 3.14 Stable.

---------------------------------------------------------------------------
[1925:1925:0101/000305:FATAL:sandbox_bpf.cc(202)] Unexpected 64bit argument
detected
[1860:1860:1231/160305:FATAL:gpu_process_transport_factory.cc(210)] Failed to
create UI context, but can't use software compositing with browser threaded
compositing. Aborting.
Handling SIGCHLD.
Successfully wrote to child pipe.
bootstrap_helper: ReserveBottomPages: NULL pointer guard page errno=22
---------------------------------------------------------------------------

[This is my first bug. Please let me know if things are not upto the mark.]

--
You are receiving this mail because:
You are watching the assignee of the bug.
_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel
