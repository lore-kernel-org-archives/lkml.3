Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaI3GYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:24:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55407 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaI3GYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:24:03 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Shuah Khan <shuahkh@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
	<20140924114235.4287f4a1@gandalf.local.home>
	<20140924115811.6eeeab8c@gandalf.local.home>
	<5422EAE2.6080005@osg.samsung.com>
	<20140924120853.0a717b7e@gandalf.local.home>
	<877g0qkj9g.fsf@sejong.aot.lge.com> <54255411.4090508@hitachi.com>
	<1411742793.1669.14.camel@leonhard> <54294543.2030003@hitachi.com>
Date: Tue, 30 Sep 2014 15:24:01 +0900
In-Reply-To: <54294543.2030003@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 29 Sep 2014 20:40:51 +0900")
Message-ID: <87r3ythbi6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Mon, 29 Sep 2014 20:40:51 +0900, Masami Hiramatsu wrote:
> (2014/09/26 23:46), Namhyung Kim wrote:
>> The perf should be built with no extra dependencies (other than libc).
>> It won't provide rich features but basic functionality (record, report,
>> stat) should be supported.  And I'm also thinking about implementing a
>> very simple elf parser for symbol loading in such a minimal build.
>
> Maybe you can install some static libraries (e.g. elfutils-libelf-devel-static
> on fedora) for enabling it. :)
> Some libraries may not work, but I could enable libelf by installing that.

Yep, installing static libs should also work.  But I'd like to have
minimal depencency especially for embedded systems.  And AFAIK cross
building elfutils/libelf always has been a PITA.

Thanks,
Namhyung
