Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaGOCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:16:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:53785 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756517AbaGOCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:16:58 -0400
Date: Mon, 14 Jul 2014 22:16:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Anton Blanchard <anton@samba.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] powerpc: Revert removing of _INIT_GLOBAL(), _STATIC()
 and _INIT_STATIC()
Message-ID: <20140714221653.335cd39c@gandalf.local.home>
In-Reply-To: <1405389955.9343.48.camel@pasglop>
References: <20140714201204.7b6fcd8e@gandalf.local.home>
	<1405389955.9343.48.camel@pasglop>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 12:05:55 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:


> Cheers,
> Ben.
> 

While I got your attention, could you please ack my patch with subject:

[RFA][PATCH 09/27] powerpc/ftrace: Add call to ftrace_graph_is_dead() in function graph code

so that I can push it through my tree.

Thanks!

-- Steve

