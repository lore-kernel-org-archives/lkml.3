Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaEEPrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbaEEPrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:47:33 -0400
Date: Mon, 5 May 2014 17:47:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] uprobes: fix scratch register selection for
	rip-relative fixups
Message-ID: <20140505154715.GA27382@redhat.com>
References: <1399043040-28366-1-git-send-email-dvlasenk@redhat.com> <20140505154559.GA27072@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505154559.GA27072@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for noise,

On 05/05, Oleg Nesterov wrote:
>
> On 05/02, Denys Vlasenko wrote:
> >
> > v2: More robust checks of vex.vvvv (32-bit mode safe),
> >     simplified scratch reg selection code,
> >     moved comments around as requested by Oleg.
>
> OK, thanks. Given that this patch was acked by Jim, I am going to
> apply it.

just in case, and the previous one, of course.

Oleg.

