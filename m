Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3AOMO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:14:58 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34428 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3AOMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:14:56 -0500
X-AuditID: 85900ec0-d5479b900000152f-8f-50f5483dab61
Message-ID: <50F5482F.4070902@hitachi.com>
Date: Tue, 15 Jan 2013 21:14:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH -tip  0/3] Move kprobes files under the kprobes
 directory
References: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp> <1357937012.5141.39.camel@gandalf.local.home>
In-Reply-To: <1357937012.5141.39.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/12 5:43), Steven Rostedt wrote:
> On Fri, 2012-09-28 at 17:15 +0900, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here are a series of patches to split ftrace-based kprobe part
>> from arch/x86/kernel/kprobes.c and to move kprobes related
>> files under arch/x86/kernel/kprobes/, according to Ingo's
>> suggestion.
>> https://lkml.org/lkml/2012/9/20/122
>>
>> Thank you,
> 
> Hi Masami,
> 
> This seems to have slipped through the cracks. Is this patch series
> still valid?

Yes, at least on the latest -tip tree, it can be applied :)
# and this series is for cleanup.

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


