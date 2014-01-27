Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaA0Tde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:33:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36819 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA0Tdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:33:33 -0500
Date: Mon, 27 Jan 2014 20:33:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Honig <ahonig@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Dave Anderson <anderson@redhat.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
Message-ID: <20140127193320.GB9636@twins.programming.kicks-ass.net>
References: <20140123173120.GA25474@www.outflux.net>
 <20140125074738.GB10565@gmail.com>
 <52E669F1.9080603@intel.com>
 <20140127152557.GA27792@gmail.com>
 <52E681B6.7020501@intel.com>
 <20140127161959.GD4941@twins.programming.kicks-ass.net>
 <20140127162226.GA3229@twins.programming.kicks-ass.net>
 <CAKB9nXucRwn78+pw1oRQ_jP_kQJuOaUzPyiH0JE5Sv9utkK1ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKB9nXucRwn78+pw1oRQ_jP_kQJuOaUzPyiH0JE5Sv9utkK1ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
