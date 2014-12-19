Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLSHbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:31:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbaLSHbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:31:43 -0500
Date: Fri, 19 Dec 2014 08:31:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Bin <huawei.libin@huawei.com>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        kpatch@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Christoph Hellwig <hch@infradead.org>, live-patching@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>,
        zhangdianfang <zhangdianfang@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>, xiexiuqi <xiexiuqi@huawei.com>
Subject: Re: [kpatch] [PATCH] livepatch v7: move x86 specific ftrace handler
 code to arch/x86
In-Reply-To: <5493C185.9020001@huawei.com>
Message-ID: <alpine.LNX.2.00.1412190831110.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-3-git-send-email-sjenning@redhat.com> <5493C185.9020001@huawei.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Li Bin wrote:

> The execution flow redirection related implemention in the livepatch
> ftrace handler is depended on the specific architecture. This patch
> introduces klp_arch_set_pc(like kgdb_arch_set_pc) interface to change
> the pt_regs.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>

Good catch, thanks.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs
