Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbaDXOdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:33:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:50250 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754085AbaDXOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:33:51 -0400
Date: Thu, 24 Apr 2014 10:33:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: kbuild test robot status reports
Message-ID: <20140424103349.28534973@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

I believe in Kernel Summit, we asked about having a notifier for when
your tests finish even if it didn't find anything. I've been told that
this has been implemented.

First I would like to request tests run on my linux-trace.git after
things have been pushed to it, notify me with a success (or failed)
status. I'd like to know when things are finished.

Next, and this is why I Cc'd Konstantin, maybe it would be prudent to
have a web site show the status of your tests?  Where we can see if a
test is in progress, finished, found new errors or not.

Ideally, it would be hosted on kernel.org. Maybe you and Konstantin
could organize something. Maybe just a redirect to another website. I
feel this would be very useful to have. That way, I don't need to ask
to be emailed, but instead just go check a website to see where the
test is at.

Maybe you already have this?

Thanks or all you effort,

-- Steve
