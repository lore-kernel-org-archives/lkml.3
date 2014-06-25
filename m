Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbaFYPf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:35:26 -0400
Received: from kanga.kvack.org ([205.233.56.17]:44558 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbaFYPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:35:22 -0400
Date: Wed, 25 Jun 2014 11:35:20 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux-foundation.org, kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] percpu-refcount, aio: use percpu_ref_cancel_init() in ioctx_alloc()
Message-ID: <20140625153520.GT23137@kvack.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org> <1403053685-28240-2-git-send-email-tj@kernel.org> <20140625143112.GR23137@kvack.org> <20140625145634.GD26883@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625145634.GD26883@htj.dyndns.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Jun 25, 2014 at 10:56:34AM -0400, Tejun Heo wrote:
> Hello, Benjamin.
...
> It'd probably easier if I route this through percpu tree with the rest
> of changes as there are further changes on the aio side (trivial but
> still), so we'd end up having to do pulling dance back and forth.  The
> changes on aio side are mostly trivial.  Can I route them through
> percpu tree with your acks?

Sure, no problem -- add my acks and proceed.  I don't think there should 
be any conflicts.  Cheers,

		-ben

> Thanks.
> 
> -- 
> tejun

-- 
"Thought is the essence of where you are now."
