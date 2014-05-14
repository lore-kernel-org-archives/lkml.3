Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaENV5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:57:13 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:37268 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaENV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:57:11 -0400
Date: Wed, 14 May 2014 17:57:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140514215707.GG15690@htj.dyndns.org>
References: <20140514174749.1ec4d37f@canb.auug.org.au>
 <20140514145520.f010e4593071cf5a756ddc5b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514145520.f010e4593071cf5a756ddc5b@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 14, 2014 at 02:55:20PM -0700, Andrew Morton wrote:
> > @@ -6026,7 +6026,7 @@ static struct cftype mem_cgroup_files[] = {
> >  	{
> >  		.name = "low_limit_in_bytes",
> >  		.private = MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
> > -		.write_string = mem_cgroup_write,
> > +		.write = mem_cgroup_write,
> >  		.read_u64 = mem_cgroup_read_u64,
> >  	},
> 
> Renaming buffer to buf was rather unneeded.
> 
> I have 24 patches here against mm/memcontrol.c.  Go gently, please.

Yeah, sorry about that.  That conflict wasn't necessary.

Thanks.

-- 
tejun
