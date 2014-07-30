Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaG3TbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:31:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaG3TbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:31:04 -0400
Message-ID: <53D947F3.6010301@canonical.com>
Date: Wed, 30 Jul 2014 15:30:59 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: jwerner@chromium.org, mathias.nyman@linux.intel.com,
        Greg KH <gregkh@linuxfoundation.org>,
        Dustin Kirkland <dustin.kirkland@canonical.com>
Subject: [REVERT][v3.16-rc7][STABLE] usb: xhci: Prefer endpoint context dequeue
 pointer over stopped_trb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A bug report was opened against Ubuntu[0].  After a kernel bisect, it
was found that reverting the following commit resolved this bug:

commit 1f81b6d22a5980955b01e08cf27fb745dc9b686f
Author: Julius Werner <jwerner@chromium.org>
Date:   Fri Apr 25 19:20:13 2014 +0300

    usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Please consider reverting commit SHA1 in the next mainline release as
well as the affected stable releases.  It was included upstream as of
v3.15-rc3. 

An upstream bug report can be found at:
https://bugzilla.kernel.org/show_bug.cgi?id=75521


Julius, I was hoping to get your feedback, since you are the patch
author.  Do you think gathering any additional data will help diagnose
this issue, or would it be best to continue with this revert request?

Sincerely,

Joseph Salisbury


[0] http://pad.lv/1350480
