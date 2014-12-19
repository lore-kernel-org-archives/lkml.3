Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaLSGMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:12:49 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:30355 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaLSGMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:12:47 -0500
Message-ID: <5493C1C9.70909@huawei.com>
Date: Fri, 19 Dec 2014 14:12:25 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        "Steven Rostedt" <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>
CC: <kpatch@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Christoph Hellwig <hch@infradead.org>, <live-patching@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        zhangdianfang <zhangdianfang@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>, xiexiuqi <xiexiuqi@huawei.com>
Subject: Re: [kpatch] [PATCH] livepatch v7: move x86 specific ftrace handler
 code to arch/x86
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-3-git-send-email-sjenning@redhat.com> <5493B997.6060606@huawei.com>
In-Reply-To: <5493B997.6060606@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry! Bad format, please ignore this patch.

On 2014/12/19 13:37, Li Bin wrote:
> The execution flow redirection related implemention in the livepatch
> ftrace handler is depended on the specific architecture. This patch
> introduces klp_arch_set_pc(like kgdb_arch_set_pc) interface to change
> the pt_regs.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>


