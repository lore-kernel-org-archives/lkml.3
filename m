Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3GXSwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:52:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3GXSwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:52:09 -0400
Date: Wed, 24 Jul 2013 20:46:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] tracing: open/delete fixes
Message-ID: <20130724184640.GA21322@redhat.com>
References: <20130723205854.GA9036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723205854.GA9036@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Oleg Nesterov wrote:
>
> Will try to test tomorrow.

Well, it seems to work "as expected", but I forgot about debugfs
problems.

And I am not sure I understand these problems correctly, will try
to report more tomorrow. This makes me think again that perhaps
the subsystem logic is not correct, but probably I misunderstood
it for the 2nd time.

Oleg.

