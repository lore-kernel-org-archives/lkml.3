Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaJHECh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:02:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37315 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaJHECg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:02:36 -0400
Message-ID: <5434B755.3080607@hitachi.com>
Date: Wed, 08 Oct 2014 13:02:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH ftrace/for-next ] tracing/kprobes: Replace startup
 test with selftest script
References: <20141006114806.2573.63966.stgit@kbuild-f20.novalocal> <20141006183349.60998821@gandalf.local.home> <5433817C.3000206@hitachi.com> <20141007120530.136312fd@gandalf.local.home> <54349A95.6040309@hitachi.com> <20141007222050.59e076e7@gandalf.local.home>
In-Reply-To: <20141007222050.59e076e7@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/08 11:20), Steven Rostedt wrote:
> On Wed, 08 Oct 2014 10:59:49 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>  
>>> Both of these have valid reasons staying in the kernel and I don't see
>>> either as dead weight. Is there a maintenance issue with keeping it in
>>> the kernel? There doesn't seem to be much done to it. It seems
>>> untouched for over a year, and that was to add support for multiple
>>> buffers.
>>
>> Keeping it has no issue. But it's much easier to expand the test
>> in userspace than the kernel code. I'll add more feature tests in
>> kselftest, but not in this code. This means that this startup
>> test code will get behind.
> 
> And that's exactly what I expect you to do. I have lots of tests to
> test ftrace, but what gets tested at kernel startup is just a bare
> minimum, and that's all it needs to be. I don't expect you to extend
> the start up self tests. That should be only done for the scripts. But
> we have this start up test and I don't see a reason to get rid of it.
> If anything, it gives me warm fuzzies in my stomach when I see it
> pass :-)
> 
> The start up tests in the kernel should really just be the basic of the
> basic tests, that give a small sanity check that a change didn't
> totally screw things up.
> 
> Can you send a new patch that doesn't remove the start up test?

OK, I'll send it asap :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


