Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3EFWtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:49:52 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:38107 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945Ab3EFWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:49:51 -0400
Date: Mon, 6 May 2013 15:49:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: Make schedule_work() available again to non
 GPL modules
Message-ID: <20130506224945.GI800@mtj.dyndns.org>
References: <1367876695-3697-1-git-send-email-marc.dionne@your-file-system.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367876695-3697-1-git-send-email-marc.dionne@your-file-system.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:44:55PM -0400, Marc Dionne wrote:
> Commit 8425e3d5bdbe ("workqueue: inline trivial wrappers") changed
> schedule_work() and schedule_delayed_work() to inline wrappers,
> but these rely on some symbols that are EXPORT_SYMBOL_GPL, while
> the original functions were EXPORT_SYMBOL.  This has the effect of
> changing the licensing requirement for these functions and making
> them unavailable to non GPL modules.
> 
> Make them available again by removing the restriction on the
> required symbols.
> 
> Signed-off-by: Marc Dionne <marc.dionne@your-file-system.com>

Will apply to workqueue/for-3.10-fixes once v3.10-rc1 drops.

Thanks.

-- 
tejun
