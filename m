Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3J2Juc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:50:32 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53402 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3J2Jua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131028124218.GD16948@ghostprotocols.net>
References: <20131026122414.GA25026@gmail.com>
	<20131028082848.GA276@x4>
	<20131028090236.GA274@x4>
	<20131028093430.GB274@x4>
	<20131028123411.GB16948@ghostprotocols.net>
	<20131028124218.GD16948@ghostprotocols.net>
Date: Tue, 29 Oct 2013 10:50:30 +0100
Message-ID: <CABPqkBSKhwO03Sx7sD+0TSp6wROAWwf0p9A8V2VQZfFh+FD9Ng@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 1:42 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Mon, Oct 28, 2013 at 09:34:11AM -0300, Arnaldo Carvalho de Melo escreveu:
>> And then, when reverting it, Stephane forgot to match the number number
>> of expected entries to be matched/assigned from 8 to 5, can you try with
>> the following patch instead?
>
> Does the wording on this commit log sounds about right to you?
>
Thanks for fixing this issue.

> - Arnaldo
