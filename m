Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab3GPXoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:44:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573Ab3GPXoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:44:08 -0400
Message-ID: <51E5DAA5.3010806@zytor.com>
Date: Tue, 16 Jul 2013 16:43:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
References: <20130716183441.GA14232@www.outflux.net> <CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com> <CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com> <1374006818.6458.62.camel@gandalf.local.home> <CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com> <51E5C31C.8000606@zytor.com> <CAE9FiQW-3H=rx-VewjMQjx2EOwcyDt351aQ0wnP8op6ZLViZag@mail.gmail.com> <51E5C65A.9010605@zytor.com> <CAE9FiQVMQyhy57MhrkCH7TYqhwgb5tHFjSxhCh8KcN+DNuXE4Q@mail.gmail.com>
In-Reply-To: <CAE9FiQVMQyhy57MhrkCH7TYqhwgb5tHFjSxhCh8KcN+DNuXE4Q@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 04:39 PM, Yinghai Lu wrote:
> 
> ok. so the old code is just for optimization to keep it cacheline aligned?
> 

To the best of my knowledge.  I guess I should look through the git log
to make sure it isn't some old erratum fix.

	-hpa

