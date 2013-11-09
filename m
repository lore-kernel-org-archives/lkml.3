Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3KIPWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:22:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3KIPWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:22:00 -0500
Date: Sat, 9 Nov 2013 16:23:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131109152313.GA14630@redhat.com>
References: <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com> <20131106173754.GA11299@redhat.com> <87a9hgwqal.fsf@sejong.aot.lge.com> <527DA997.4080306@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527DA997.4080306@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Masami Hiramatsu wrote:
>
> In that case, I suggest you to use "@+addr" for the relative address,
> since that is an offset, isn't that? :)

Agreed, @+addr looks better!

> BTW, it seems that @addr syntax is hard to use for uprobes, because
> current uprobes is based on a binary, not a process, we cannot specify
> which process is probed when we define it.

Yes, exactly. That is why we suggest that user-space should pass the
ip-relative address (actually offset). This should hopefully solve all
problems with relocations.

Oleg.

