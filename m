Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaCCW2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:28:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:23977 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754951AbaCCW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:28:08 -0500
Date: Mon, 3 Mar 2014 17:28:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Question about -rc and stable patches
Message-ID: <20140303172806.4486f65a@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and Greg,

Recently I have been sent patches that fix a bug in the enabling of
ftrace function tracer, where if something goes wrong with the
enabling (or disabling), it can cause a crash of the computer.

Now, my question is, the bug requires something to go wrong at a point
where I've never seen it go wrong before. But if you inject a problem
(code that makes it fail on the 1000th iteration), sure enough, the
recovery is not correct and the machine crashes.

Is this fix something that I should push to -rc as well as to stable?
Or should I just add this to my 3.15 queue, as I have never heard of
someone triggering it. The only report is from someone that was testing
the failure cases.

Thanks,

-- Steve
