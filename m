Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaDDHCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:02:25 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:39485 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaDDHCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:02:22 -0400
MIME-Version: 1.0
Date: Fri, 4 Apr 2014 00:02:21 -0700
Message-ID: <CAES_P+8kwWhaFoJPvvbDh6rJ0+VTpFutqUGefZmbghN21XtVdw@mail.gmail.com>
Subject: Query for time tracking between userspace and kernelspace
From: noman pouigt <variksla@gmail.com>
To: john.stultz@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Probably this question belongs to kernelnewbies
list but I think i will get accurate answer from here.

I am doing some optimization in kernel video driver
code to reduce the latency from the time buffer
is given to the time it is displayed.

Userspace:
t1 = gettimeofday()

Kernelspace:
t2 = do_gettimeofday()

Using debugfs i am copying t2 to userspace and
subtracting the result.

latency = t2 - t1

Would this be accurate? I know there is context
switch involved and other stuff but this is the method
i came up with. Any better way?

System: ARM (Android)
Kernel- 3.10
