Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3EFS7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:59:25 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:43891 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3EFS7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:59:23 -0400
Message-ID: <5187FD86.9000005@colorfullife.com>
Date: Mon, 06 May 2013 20:59:18 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: manual merge of the akpm tree with the  tree
References: <20130506135109.9c0b24ea1e22784fb28ae6b9@canb.auug.org.au>
In-Reply-To: <20130506135109.9c0b24ea1e22784fb28ae6b9@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/06/2013 05:51 AM, Stephen Rothwell wrote:
> Hi Andrew,
>
> Today's linux-next merge of the akpm tree got a conflict in ipc/sem.c
> between commit 321310ced2d6 ("ipc: move sem_obtain_lock() rcu locking
> into the only caller") from Linus' tree and commit "ipc/sem.c:
> alternatives to preempt_disable()" from the akpm tree.
I would propose that 'ipc/sem.c: alternatives to preempt_disable()' is 
dropped.

As explained in the commit:
That patch is for CONFIG_PREEMPT_RT, it should go into their tree.

--
     Manfred
