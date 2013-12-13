Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3LMQLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:11:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:39144 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800Ab3LMQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:11:44 -0500
Date: Fri, 13 Dec 2013 11:11:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <liuj97@gmail.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Andrew Jones <drjones@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v6 7/7] jump_label: use defined macros instead of
 hard-coding for better readability
Message-ID: <20131213111140.064b9616@gandalf.local.home>
In-Reply-To: <20131213160041.GK19177@mudshark.cambridge.arm.com>
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
	<1386691433-6827-8-git-send-email-liuj97@gmail.com>
	<20131213160041.GK19177@mudshark.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Jason Baron too (the original author) ]

On Fri, 13 Dec 2013 16:00:41 +0000
Will Deacon <will.deacon@arm.com> wrote:

> On Tue, Dec 10, 2013 at 04:03:53PM +0000, Jiang Liu wrote:
> > Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
> > readability.
> > 
> > Signed-off-by: Jiang Liu <liuj97@gmail.com>
> > ---
> >  include/linux/jump_label.h | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> Whilst this looks alright to me, I think we probably need an ack from Steve
> in order to take changes to the core code.
> 
> Will
> 

Thanks for the heads up. I'll take a look at it.

-- Steve
