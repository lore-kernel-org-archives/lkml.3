Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaJQXyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 19:54:38 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51902 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJQXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 19:54:37 -0400
To: oleg@redhat.com, akpm@linux-foundation.org, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] (Was: kernel/kmod: fix use-after-free of thesub_infostructure)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20141016174209.GB18318@redhat.com>
	<201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
	<20141016215834.GA28864@redhat.com>
	<20141017093653.6fa60dff@mschwide>
	<20141017191557.GA22270@redhat.com>
In-Reply-To: <20141017191557.GA22270@redhat.com>
Message-Id: <201410180854.HDB69223.JQLVSOFFHtFOMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 18 Oct 2014 08:54:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 10/17, Martin Schwidefsky wrote:
> >
> > Version 2 of the patch.
> 
> On top of this patch.
> 
> Tetsuo, can you review?
> 
> Oleg.
> 
>  kernel/kmod.c |   43 +++++--------------------------------------
>  1 files changed, 5 insertions(+), 38 deletions(-)
> 
Looks OK to me.

Reviewed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
