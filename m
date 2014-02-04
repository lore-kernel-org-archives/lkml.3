Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaBDXbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:31:22 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53125 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaBDXbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:31:20 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-e9-52f1784657f7
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: [PATCHSET 0/5] tracing/uprobes: Support multi buffer and event trigger
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
	<87mwi83hvf.fsf@sejong.aot.lge.com>
	<20140203205828.4e5b1592@gandalf.local.home>
Date: Wed, 05 Feb 2014 08:31:17 +0900
In-Reply-To: <20140203205828.4e5b1592@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 3 Feb 2014 20:58:28 -0500")
Message-ID: <877g9a316i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Mon, 3 Feb 2014 20:58:28 -0500, Steven Rostedt wrote:
> On Mon, 03 Feb 2014 14:06:12 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Ping!
>
> Hi Namhyung,
>
> I plan on getting these ready for the 3.15 queue. There was a bit too
> much in 3.14 to add these on top of at the last minute.

I'm fine with it.

>
> Currently, I'm working on some bugs at work as well as some things I
> found in mainline. I'll be reviewing these when I get a chance.

Great, thanks!
Namhyung
