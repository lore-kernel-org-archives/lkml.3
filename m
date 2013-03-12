Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3CLVB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:01:27 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:64304 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab3CLVB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:01:26 -0400
Date: Tue, 12 Mar 2013 14:01:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] async: simple cleanups
Message-ID: <20130312210121.GJ25266@htj.dyndns.org>
References: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
 <20130312210034.GI25266@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312210034.GI25266@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:00:34PM -0700, Tejun Heo wrote:
> On Tue, Mar 12, 2013 at 12:30:01AM +0800, Lai Jiangshan wrote:
> > I found somethings need to be cleanup when I watch what has been changed
> > to async.c.
> > 
> > Lai Jiangshan (3):
> >   async: simplify lowest_in_progress()
> >   async: remove unused @node from struct async_domain
> >   async: rename and redefine async_func_ptr
> 
> Applied with cosmetic whitespace adjustments (why change the
> formatting in the second patch?  For the 80 col limit?)

Oops, the branch is wq/for-3.10-async.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-async

Thanks.

-- 
tejun
