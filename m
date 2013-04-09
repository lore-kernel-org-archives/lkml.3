Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937105Ab3DIQHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:07:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936191Ab3DIQHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:07:16 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9jKC2g6i2PgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=J61P-NbaYoAA:10 a=bjLwvP3ShhZRSLmPh7UA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365523634.25498.74.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] trace-cmd: Support trace_clock extraction
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 09 Apr 2013 12:07:14 -0400
In-Reply-To: <1365523237.25498.70.camel@gandalf.local.home>
References: <20130405015439.19807.43932.stgit@yunodevel>
	 <20130405015444.19807.91495.stgit@yunodevel>
	 <1365523237.25498.70.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 12:00 -0400, Steven Rostedt wrote:

> I think it's time for me to push my latest updates to trace-cmd. As this
> will probably end up being the 3.0 version. I have examples there that
> use the options feature for more extensions that you can look at.
> 

I just pushed my latest changes. Specifically look at these:

commit d56f30679f9811a91ed471c8e081cc7ffbed1e62
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Wed Mar 6 11:31:39 2013 -0500

    trace-cmd: Add recording to buffer instances


commit 417c903f3b91e012ee0dfedaf0bb8e5cc82780e1
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Wed Mar 6 16:12:16 2013 -0500

    trace-cmd: Add support for multi-buffers in report


It allows trace-cmd to record multiple buffers into the trace.dat file
using the options. Old trace-cmd can still read this trace.dat file, but
it will just not report the multiple buffers. But it wont break, and
will still report the main buffers.

-- Steve



