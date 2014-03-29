Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaC2BqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:46:04 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62901 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaC2BqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140328160853.GB1041@kroah.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<20140328160853.GB1041@kroah.com>
Date: Sat, 29 Mar 2014 09:46:01 +0800
Message-ID: <CAGdX0WFW+O8ktJP4a_ympoF=ziZd8CPKKrBEW4C-rkOUky-nzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for Linux
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 12:08 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 28, 2014 at 09:47:21AM -0400, Jovi Zhangwei wrote:
>> Hi All,
>>
>> The following set of patches add ktap tracing tool.
>
> Yeah!
>
> Thanks for putting this patch set together, it looks good.
>
> But, why hide the kernel portions of ktap in the tools/ directory?  Is
> that ok with everyone else?  I don't expect to see kernel code burried
> in that directory, so any kernel API changes that might happen, might
> not get propagated into that location.
>
Reasonable, I will try to put kernel module side into kernel/trace/ktap
directory in next version.

There have some duplicated code with kernel/trace/*.c, then maybe
we can integrate it if ktap location more closer with ftrace.

Thanks for this suggestion.

Jovi
