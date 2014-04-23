Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaDWGEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:04:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53070 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaDWGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:03:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, William Cohen <wcohen@redhat.com>
Subject: Re: mapping instructions to dynamic languages like java, python, ruby
References: <20140422180305.GK8488@redhat.com>
	<CABPqkBTJ4==4FF2KLVGzvpGSX_RhHVZWUH5h9Vvi+XG_xJSUEQ@mail.gmail.com>
Date: Wed, 23 Apr 2014 15:03:56 +0900
In-Reply-To: <CABPqkBTJ4==4FF2KLVGzvpGSX_RhHVZWUH5h9Vvi+XG_xJSUEQ@mail.gmail.com>
	(Stephane Eranian's message of "Tue, 22 Apr 2014 21:05:11 +0200")
Message-ID: <87tx9kr38z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Tue, 22 Apr 2014 21:05:11 +0200, Stephane Eranian wrote:
> Hi Don,
>
> I have been working on the JIT code support for a while now.
> I have something working well for more than Java now. It reuses
> some of the same principles as the OProfile support but extend
> them to support more advanced JIT features such as address
> recycling and code movements.
>
> I intend to contribute that code for perf once it is finalized.
> Note that it uses a module developed by Sonny Rao to
> export the perf timestamp time source via a posix-clock.
> This clock discussion has been going on for a while and
> never reached a conclusion. So I decided to go with the
> simple posix-clock module for the time being.

I'm looking forward to seeing your patches soon!

Thanks,
Namhyung
