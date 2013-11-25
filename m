Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3KYMJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3KYMJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:09:49 -0500
Date: Mon, 25 Nov 2013 13:10:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131125121042.GA23829@redhat.com>
References: <20131108190003.GA12755@redhat.com> <20131111071151.GA2559@linux.vnet.ibm.com> <20131111165543.GA12233@redhat.com> <20131112174302.GH2559@linux.vnet.ibm.com> <20131112192038.GA7748@redhat.com> <5291B694.8040003@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5291B694.8040003@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Masami Hiramatsu wrote:
>
> Ping?
>
> Is this already pulled?
> I think it is enough discussed and reviewed.

Yes, thanks, this is already in tip/perf/core.

Oleg.

