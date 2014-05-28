Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaE1OWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:22:17 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:45096 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaE1OWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:22:15 -0400
Date: Wed, 28 May 2014 10:22:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix busted pr_info conversion in kernel/workqueue.c
Message-ID: <20140528142212.GC1419@htj.dyndns.org>
References: <14251.1401215339@turing-police.cc.vt.edu>
 <20140527204433.e22e1cca95d2b4a5dac5f960@skynet.be>
 <25551.1401222429@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25551.1401222429@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 04:27:09PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 May 2014 20:44:33 +0200, Fabian Frederick said:
> > Hello Valdis,
> >
> > 	I thought Tejun directly reverted that patch (Joe Perches noticed
> >  the level problem just after submit).Anyway, problem is solved now :)
> 
> Tejun - can you see if that patch in fact got reverted?  It made it
> into the linux-next 20140529 tree somehow. (Perhaps the revert is in
> a tree that didn't get pushed/pulled correctly?)

Hah, thought I did.  Apparently didn't.  Applying the patch.

Thanks.

-- 
tejun
