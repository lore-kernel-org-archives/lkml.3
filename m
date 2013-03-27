Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3C0T6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3C0T6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:58:43 -0400
Date: Wed, 27 Mar 2013 15:58:39 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] idr: add idr_alloc_cyclic and convert existing
 cyclic users
Message-ID: <20130327155839.63de3e2c@tlielax.poochiereds.net>
In-Reply-To: <20130327125053.45a90e31186ac968bed644a4@linux-foundation.org>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
	<20130327193847.GF7395@htj.dyndns.org>
	<20130327125053.45a90e31186ac968bed644a4@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 12:50:53 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 Mar 2013 12:38:47 -0700 Tejun Heo <tj@kernel.org> wrote:
> 
> > On Wed, Mar 27, 2013 at 03:29:32PM -0400, Jeff Layton wrote:
> > > (Andrew, I think this is probably best routed via -mm since it touches
> > > several different places)
> > 
> > Yeap, I think it'd be best to route these through -mm.
> > 
> > Please feel free to add Reviewed-by: Tejun Heo <tj@kernel.org> for the
> > whole series.
> 
> I understand that Jeff will be sending a v2 series?
> 

Yes, just sent a few mins ago...

> btw, I'll be away-from-keyboard until the end of next week.  Nobody be
> alarmed ;)
> 

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>
