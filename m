Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab3FRT3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3FRT3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:29:02 -0400
Date: Tue, 18 Jun 2013 21:24:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH 2/3] tracing/kprobes: Kill probe_enable_lock
Message-ID: <20130618192414.GA19488@redhat.com>
References: <20130616172149.GA8540@redhat.com> <51BE97C0.1070203@hitachi.com> <20130617151841.GA32267@redhat.com> <51BFD6EF.1060805@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BFD6EF.1060805@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Masami Hiramatsu wrote:
>
> Oh, I agree with removing probe_enable_lock itself :)
> I just concerned only about the exceptional case of __init test
> function, which can mislead someone to use enable/disable_trace_probe
> at other racy point.

Ah, understand.

OK, I'll send v2 with the updated comments plus the additional patch
tomorrow.

Thanks!

Oleg.

