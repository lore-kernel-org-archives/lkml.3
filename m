Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaD0L3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 07:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaD0L3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 07:29:33 -0400
Date: Sun, 27 Apr 2014 13:29:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC PATCH] uprobes: add comment with insn opcodes, mnemonics
	and why we dont support them
Message-ID: <20140427112925.GA17727@redhat.com>
References: <1398533370-8865-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398533370-8865-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Denys Vlasenko wrote:
>
> After adding these, it's clear we have some awkward choices there.
> some valid instructions are prohibited from uprobing while
> several invalid ones are allowed.

Denys, both patches conflict with the pending changes in uprobe.c.

Could you resend after the next PULL request?

Oleg.

