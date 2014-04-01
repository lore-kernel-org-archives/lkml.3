Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaDAQC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaDAQCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:02:25 -0400
Date: Tue, 1 Apr 2014 17:01:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes/x86: Introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140401150126.GA22042@redhat.com>
References: <20140331194337.GA9257@redhat.com> <20140331194415.GA9307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331194415.GA9307@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Oleg Nesterov wrote:
>
> +static struct uprobe_xol_ops defaule_xop_ops = {
> +	.pre_xol  = default_pre_xol_op,
> +	.post_xol = default_post_xol_op,
> +};

...

> +	auprobe->ops = &defaule_xop_ops;

Cough. At least the name is the same ;) But I obviously meant "default_xol_ops".
Another reason for v2.

Oleg.

