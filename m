Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab3ENSxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:53:31 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:49123 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENSxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:53:30 -0400
Date: Tue, 14 May 2013 11:53:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: Make schedule_work() available again to non
 GPL modules
Message-ID: <20130514185325.GS6795@mtj.dyndns.org>
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

Applied to wq/for-3.10-fixes.

Thanks.

-- 
tejun
