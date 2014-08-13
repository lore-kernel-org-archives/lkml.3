Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaHMHO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:14:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53872 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMHO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:14:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] ftrace: Add a ftrace test collection
References: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
	<20140805173752.1de5f1c2@gandalf.local.home>
	<8738d0euyv.fsf@sejong.aot.lge.com>
Date: Wed, 13 Aug 2014 16:14:56 +0900
In-Reply-To: <8738d0euyv.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Wed, 13 Aug 2014 15:59:04 +0900")
Message-ID: <87tx5gdfnz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 15:59:04 +0900, Namhyung Kim wrote:
> On Tue, 5 Aug 2014 17:37:52 -0400, Steven Rostedt wrote:
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>  - What's the good naming method of testcases?
>
> I'm okay with the ftracetest, but tracing-test may be an option. :)

Ouch, did you say about *.tc file name?  I have no problem with that too
anyway :)

Thanks,
Namhyung
