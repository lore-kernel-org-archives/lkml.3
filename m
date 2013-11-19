Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3KSJdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:33:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3KSJdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:33:15 -0500
Date: Tue, 19 Nov 2013 10:33:02 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Petr Machata <pmachata@redhat.com>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
Message-ID: <20131119093302.GA18286@host2.jankratochvil.net>
References: <20131118142653.GA27191@gmail.com>
 <20131118174945.GD24375@krava.brq.redhat.com>
 <20131118201619.GA26312@host2.jankratochvil.net>
 <CAFrcx1mnh2odWmzJMcKKwR=5F2dydAQctp+1LKan0w5NcFaexA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mnh2odWmzJMcKKwR=5F2dydAQctp+1LKan0w5NcFaexA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 10:26:42 +0100, Jean Pihet wrote:
> Do you know about the support of AARCH64, both in 64-bit and 32-bit
> (compat) mode?
> I would be glad to give it a try.

Please move this topic to:
	https://lists.fedorahosted.org/mailman/listinfo/elfutils-devel

aarch64 elfutils port is now posted by Petr Machata.
The elfutils unwinder part for aarch64 (or arm) has not been written yet.


Jan
