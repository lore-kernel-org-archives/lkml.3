Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3KKIqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:46:18 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:63713 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3KKIqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:46:06 -0500
Date: Mon, 11 Nov 2013 09:46:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: uprobe_copy_process() and copy_insn() fixes
Message-ID: <20131111084602.GD12405@gmail.com>
References: <20131109161857.GA17484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109161857.GA17484@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Pulled, thanks a lot Oleg!

> I do not like to spam you, but I think that at least the 1st patch 
> should be merged now, along with other retprobe && fork fixed.

It's not possible for you to spam me with patches! :-)

Thanks,

	Ingo
