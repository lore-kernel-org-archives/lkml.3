Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaHEElW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:41:22 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48383 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaHEElV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:41:21 -0400
Message-ID: <1407213677.6373.4.camel@marge.simpson.net>
Subject: Re: [PATCH? v2] x86: reimplement ___preempt_schedule*() using THUNK
 helpers
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Date: Tue, 05 Aug 2014 06:41:17 +0200
In-Reply-To: <20140804173646.GA18520@redhat.com>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
	 <1407158386-6201-5-git-send-email-dvlasenk@redhat.com>
	 <20140804170519.GA17466@redhat.com>
	 <20140804171814.GU19379@twins.programming.kicks-ass.net>
	 <20140804173646.GA18520@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 19:36 +0200, Oleg Nesterov wrote:

> Seems to work at least on x86_64, but I do not know how to test, lets see
> what HPA thinks.

Seeing the words "preempt" and "test", blindly feeding it to -rt seemed
like a reasonable thing to do over morning java (la la la;)... it hasn't
spat it out yet.

-Mike

