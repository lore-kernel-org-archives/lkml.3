Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaKNJIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:08:34 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36683 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaKNJIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:08:30 -0500
Message-ID: <5465C685.9060006@linaro.org>
Date: Fri, 14 Nov 2014 09:08:21 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH RESEND 3.18-rc3 v2 1/2] trace: kdb: Fix kernel panic during
 ftdump
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>	<1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>	<1415277716-19419-2-git-send-email-daniel.thompson@linaro.org> <20141113212646.6d720886@gandalf.local.home>
In-Reply-To: <20141113212646.6d720886@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/14 02:26, Steven Rostedt wrote:
> On Thu,  6 Nov 2014 12:41:55 +0000
> Daniel Thompson <daniel.thompson@linaro.org> wrote:
> 
>> Currently kdb's ftdump command unconditionally crashes due to a null
>> pointer de-reference whenever the command is run. This in turn causes
>> the kernel to panic.
>>
>> The abridged stacktrace (gathered with ARCH=arm) is:
>> --- cut here ---
> 
> This is a nasty line. "git am " truncated the change log there thinking
> it was the end of the change log (that '---' did it).

Oops. Looks like I shall have to train myself out of that particular
habit (which will be tough, since I've used it long enough to be ingrained).

Will repost as soon as I've thought about your other comments.

Daniel.
