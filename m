Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaDCUZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:25:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbaDCUZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:25:31 -0400
Date: Thu, 3 Apr 2014 22:00:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8-9/7] uprobes/x86: introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140403200015.GC12639@redhat.com>
References: <20140331194337.GA9257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331194337.GA9257@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Oleg Nesterov wrote:
>
> when I send the fixes.

Damn. All I can say - sorry for delay. Still no fixes.

I only finished v2, but do not have time to add the acks I got and
resend. Apart from cosmetic changes the resulting code is the same
plus the new 2 patches I am sending in reply to this message.

Just in case, let me repeat. I really want to separate these preps
and the actual fixes. Because I believe that they make sense in any
case, no matter how we will actually fix the problem.

Oleg.

