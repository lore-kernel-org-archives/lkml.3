Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3DJL4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:56:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3DJL4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:56:09 -0400
Message-ID: <1365594957.30071.66.camel@laptop>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Apr 2013 13:55:57 +0200
In-Reply-To: <1365594552.30071.63.camel@laptop>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
	 <1365586878.30071.33.camel@laptop>
	 <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
	 <1365594552.30071.63.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 13:49 +0200, Peter Zijlstra wrote:

> Hmm.. the 15h old interface bits got merged? I thought I kept telling
> that should be done like the intel uncore stuff since the hardware
> interface wasn't retarded anymore.

Ah well, that crap seems to have slipped in in Feb when I was still a
near vegetable and not paying much attention.

/me curses a bit.

I don't suppose we can deprecate it and remove this stuff? 

