Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaAQVY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 16:24:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaAQVYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 16:24:25 -0500
Date: Fri, 17 Jan 2014 13:24:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [ipc] 5769cf63: LTP semget02 TFAILs
Message-Id: <20140117132423.300e13a26a069e56f79815fd@linux-foundation.org>
In-Reply-To: <20140117102428.GC8751@localhost>
References: <20140117102428.GC8751@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014 18:24:28 +0800 Fengguang Wu <fengguang.wu@intel.com> wrote:

> Hi Davidlohr,
> 
> We noticed LTP test failures
> 
>         ltp.msgget02.1.TFAIL
>         ltp.semget02.2.TFAIL
>         ltp.semget02.3.TFAIL
> 
> and the first bad commit is
> 
> commit 5769cf6355d87f63906b3e51887eff7017c39217
> Author:     Davidlohr Bueso <davidlohr@hp.com>
> AuthorDate: Wed Jan 15 16:56:01 2014 +1100
> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> CommitDate: Wed Jan 15 16:56:01 2014 +1100
> 
>     ipc: share ids rwsem when possible in ipcget_public
>     

Thanks (a lot). I'll disable that patch for now.
