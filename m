Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3GDFeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:34:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51304 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GDFeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:34:19 -0400
X-AuditID: 9c930197-b7c79ae000003295-8d-51d50959c24b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/12] tracing/uprobes: Add support for more fetch methods
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
	<1372861350.22688.101.camel@gandalf.local.home>
Date: Thu, 04 Jul 2013 14:34:17 +0900
In-Reply-To: <1372861350.22688.101.camel@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 03 Jul 2013 10:22:30 -0400")
Message-ID: <87y59mzy5i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, 03 Jul 2013 10:22:30 -0400, Steven Rostedt wrote:
> On Wed, 2013-07-03 at 21:35 +0900, Namhyung Kim wrote:
>> Hello,
>> 
>> This patchset implements memory (address), stack[N], deference,
>> bitfield and retval (it needs uretprobe tho) fetch methods for
>> uprobes.  It's based on the previous work [1] done by Hyeoncheol Lee.
>
> Sending out new code in the middle of a merge window isn't the best
> timing. You may want to ping us again after the merge window closes, as
> focus currently is on getting 3.11 changes in and working. This patchset
> might get forgotten.

Okay, I'll send a ping to you after the merge window closed.

Thanks,
Namhyung
