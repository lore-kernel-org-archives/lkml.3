Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaD0NwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 09:52:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaD0NwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 09:52:00 -0400
Date: Sun, 27 Apr 2014 15:51:36 +0200
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
Subject: Re: [PATCH 0/4] uprobes/x86: UPROBE_FIX_IP/UPROBE_FIX_CALL cleanups
Message-ID: <20140427135136.GA27016@redhat.com>
References: <20140417200228.GA31097@redhat.com> <20140425174704.GA7898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425174704.GA7898@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Oleg Nesterov wrote:
>
> Jim, I see your email about the previous series. If we rename ->def then
> this series obviously should be updated too, but this is trivial.

Better yet, can't we rename it in a separate patch?

I agree, ->def doesn't look good. So far I am inclined to make it ->dflt,
although let me repeat I agree with any naming and I can use "dfault" as
you suggested.

But. If we rename it, then we should probably also rename default_xol_ops
and its methods accordingly, and I think that "cosmetic, renames only"
patch makes more sense.

OK?

Oleg.

