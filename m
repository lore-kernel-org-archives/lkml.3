Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3G2Lgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:36:39 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49881 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3G2Lgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:36:38 -0400
Message-ID: <51F653C2.3010407@hitachi.com>
Date: Mon, 29 Jul 2013 20:36:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] tracing: open/delete fixes
References: <20130726172513.GA3586@redhat.com>
In-Reply-To: <20130726172513.GA3586@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/27 2:25), Oleg Nesterov wrote:
> Hello.
> 
> Testing: seems to work, but assumes that debugs was fixed too. Hopefully
> "debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)"
> is fine.
> 
> (We should probably make debugfs_remove_recursive() to return the error
>  and trace_events.c should warn if it fails)
> 
> However: I am still testing this patches, so this is still mostly for
> review. I'll report if I find anything, but to remind we have other
> bugs which need more fixes. And in fact I need to re-read this series
> to convince myself it should work, I was distracted by the unexpected
> problem in debugfs.
> 
> Changes: a lot but all cosmetic, addresses the comments from Steven.
> 
> Steven, 1/6 was not changed, I assume you agreed with my reply.
> 
> Masami, I'll appreciate your review ;)

I think this is OK except for the bisecting issue, as I pointed in
reply to 6/6. ;)

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


