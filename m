Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaDDBVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 21:21:18 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:60998 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDBVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 21:21:17 -0400
MIME-Version: 1.0
Date: Fri, 4 Apr 2014 09:21:16 +0800
Message-ID: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
Subject: ktap and ebpf integration
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexei,

We talked a lot on ktap and ebpf integration in these days,
Now I think we can put into deeply to thinking out some
technical issues in there.

Firstly, I want to make sure you are support this ktap and
ebpf integration direction, I aware you have ongoing 'bpf filter'
patch set work, which actually overlapping with ktap integration
efforts (IMO the interface should be unified and simple for user,
 so I think filter debugfs file is not a good interface), so please let
me know your answer about this.

If the answer is yes, then we can go through ebpf core
improvement, for example:
- support global variable access
  this is mandatory for dynamic tracing, otherwise, there have
  no possible to run a simple script like get function execution
  time.
- support timer in kernel
  The final solution must need to support kernel timer for profiling,
  and sampling stack.
- support register multi-event in one script
- support trace_end


If the answer of first question is no, you still believe your "bpf filter"
solution is a correct way, that's means there have no need to
integrate ktap and ebpf, and don't need any ktap upstream efforts,
I 'm fine with it, then I can make another technical plan for ktap.

Thank you.

Jovi
