Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3CWSAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 14:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3CWSAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 14:00:16 -0400
Date: Sat, 23 Mar 2013 18:56:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 0/7] uretprobes: return probes implementation
Message-ID: <20130323175609.GA4076@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <20130322151034.GC17286@redhat.com> <514CCFDA.2080305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514CCFDA.2080305@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Josh Stone wrote:
>
> On 03/22/2013 08:10 AM, Oleg Nesterov wrote:
> > This looks simple, but probably we need to add the additional "ulong bp_vaddr"
> > argument for rp_handler().
>
> FWIW, in SystemTap we don't currently do anything that would need
> bp_vaddr.

I know. This is not for systemtap.

> The uprobe_consumer already gives the context, so I'm not
> sure what else you would do with the *entry* address of the function
> that just returned.

context - yes, but not address (by the time ret_handler is called).

Oleg.

