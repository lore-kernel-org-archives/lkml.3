Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaELQFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:05:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63619 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754370AbaELQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:05:37 -0400
Date: Mon, 12 May 2014 12:05:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/8] ftrace: make CALLER_ADDRx macros more generic
Message-ID: <20140512120535.041030dd@gandalf.local.home>
In-Reply-To: <20140512155811.GB4880@arm.com>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
	<1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
	<20140502151957.6978d870@gandalf.local.home>
	<20140512155811.GB4880@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 16:58:11 +0100
Will Deacon <will.deacon@arm.com> wrote:

> Akashi: did you get around to posting a new version of this patch? We can't
> take your arm64 patches until you get the core stuff merged...

I haven't seen any patches yet.

What I can also do is to create a separate branch based on mainline,
and just apply this change to the core. Then you could pull that branch
with a note to Linus that it is also in my tree with the common
ancestor.

If he pulls your work first, he'll only get that change from my tree,
and if he pulls mine first it doesn't matter as all the changes will be
there.

This is something he said at Kernel Summit that was normal procedure if
there's a change in one tree that another tree is dependent on.

-- Steve

