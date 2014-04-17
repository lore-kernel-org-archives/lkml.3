Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaDQNzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:55:47 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35087 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:55:32 -0400
Date: Thu, 17 Apr 2014 09:55:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] control groups: documentation improvements
Message-ID: <20140417135528.GE15326@htj.dyndns.org>
References: <53225C69.3010202@huawei.com>
 <53230475.5050805@gopivotal.com>
 <20140314140136.GF12613@htj.dyndns.org>
 <53230C7E.7060607@gopivotal.com>
 <533C05D8.8020600@gopivotal.com>
 <533C0DD9.1050809@gopivotal.com>
 <20140416210025.GE26632@htj.dyndns.org>
 <534FB0F5.3010904@gopivotal.com>
 <20140417131615.GH26632@htj.dyndns.org>
 <534FDB04.6050406@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FDB04.6050406@gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 17, 2014 at 02:45:40PM +0100, Glyn Normington wrote:
> >>+The sets of subsystems participating in distinct hierarchies are either
> >>+identical or disjoint. If the sets are identical, the virtual filesystems
> >>+associated with the hierarchies have identical content and a change in
> >>+one is automatically reflected in all the others.
> >
> >I can't say I'm a big fan of these definitions in mathematical terms.
> >They're so precise and useless at the same time.
>
> We would like to be both precise and readable. Please point out the
> "useless" bits and we'll try to make them better.

I think it becomes useless when mathematical precision is pursued
beyond the necessary point, forcing people to parse and analyze the
description to reach a concept she already has full understanding of.
Just using those pre-established concepts is far more efficient use of
brain power than trying to craft the precise mathematical definition
from vacuum and, [un]surprisingly, leads to lower rate of
miscommunication.

It's kinda useless to go through all the precise terms to re-define
hierarchical grouping of tasks, which is both accurate and intuitive
enough.  Adding extra descriptions to clarify ambiguities and just to
reinforce the concept would be fine but trying to build the concept
from the ground is silly at best.  Starting with something intuitive
and refining it is a far better approach.

> A given hierarchy may be associated with more than one virtual
> filesystem, in which case each of the virtual filesystems has
> identical contents to the others.

The above is inaccurate because there really is just one filesystem
(represented by a single super block).  There are multiple mount
points of the same file system, but still just single file system.
ie. mounting /dev/sdb2 in multiple places doens't really create
multiple file systems.

Thanks.

-- 
tejun
