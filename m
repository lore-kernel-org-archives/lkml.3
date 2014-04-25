Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaDYRrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaDYRrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:47:32 -0400
Date: Fri, 25 Apr 2014 19:47:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes/x86: UPROBE_FIX_IP/UPROBE_FIX_CALL cleanups
Message-ID: <20140425174704.GA7898@redhat.com>
References: <20140417200228.GA31097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417200228.GA31097@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Oleg Nesterov wrote:
>
> This series only fixes the problem. I'll send more changes to address
> some of TODO's mentioned in the changelogs later.

This is probably the last series I am sending in this thread, before the
next PULL request. This completes the changes which I planned from the
very beginning, except "emulate jczx/loopz" which I am still unsure about.

I didn't test it yet, will do of course and report if something is wrong.

Jim, I see your email about the previous series. If we rename ->def then
this series obviously should be updated too, but this is trivial.

Oleg.

 arch/x86/include/asm/uprobes.h |    3 +-
 arch/x86/kernel/uprobes.c      |   66 ++++++++++++++++------------------------
 2 files changed, 28 insertions(+), 41 deletions(-)

