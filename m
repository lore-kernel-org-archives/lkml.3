Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaLSOYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbaLSOYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:24:05 -0500
Date: Fri, 19 Dec 2014 08:23:16 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Li Bin <huawei.libin@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
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
Message-ID: <20141219142316.GA4120@treble.redhat.com>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
 <1418752700-14649-3-git-send-email-sjenning@redhat.com>
 <5493C185.9020001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5493C185.9020001@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 02:11:17PM +0800, Li Bin wrote:
> The execution flow redirection related implemention in the livepatch
> ftrace handler is depended on the specific architecture. This patch
> introduces klp_arch_set_pc(like kgdb_arch_set_pc) interface to change
> the pt_regs.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>  arch/x86/include/asm/livepatch.h |    5 +++++
>  kernel/livepatch/core.c          |    2 +-
>  2 files changed, 6 insertions(+), 1 deletions(-)

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>


-- 
Josh
