Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaIDCmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:42:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46238 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbaIDCmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:42:53 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/4] ftrace: Add a ftrace test collection
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
Date: Thu, 04 Sep 2014 11:42:51 +0900
In-Reply-To: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal> (Masami
	Hiramatsu's message of "Tue, 02 Sep 2014 11:06:32 +0000")
Message-ID: <87iol49kd0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014 11:06:32 +0000, Masami Hiramatsu wrote:
> Hi,
>
> Here is the collection of testcases for ftrace version 3.
> This is just some updates and fixes according to the 
> discussion at previous version.
>   https://lkml.org/lkml/2014/8/26/304
>
> The major updates are:
>  - Fix some expressions to work on dash (Thanks Luis!)
>  - Support UNRESOLVED/UNTESTED/UNSUPPORTED results for testcase.
>    Those are POSIX 1003.3 standard.
>    (see http://www.gnu.org/software/dejagnu/manual/x47.html for
>     more details)
>  - Fix to show error logs.
>
> ftracetest is a small dash script for testing ftrace features.
> It will be required to add a unit test for each new feature
> after this is merged, because of preventing feature regressions.
>
> This version still be out of the selftest. However, at the kernel
> summit, I talked with Shuah about that. And since the kselftest
> will be the standard kernel unit test framework, I agreed to
> move this under the selftest. But I also would like to ask Steven
> and Namhyung to agree with it before moving.
>
> Actually, since we've already has similar shell-script base
> testcase under kselftest, we can easily move this under
> selftests.

By [k]selftest, did you mean tools/testing/selftests/ ?

Anyway I have no objection to the move.

Thanks for your work!
Namhyung
