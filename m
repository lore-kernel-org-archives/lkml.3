Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031122Ab3DSQnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:43:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031065Ab3DSQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:43:15 -0400
Date: Fri, 19 Apr 2013 09:43:10 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130419164310.GA29871@dhcp22.suse.cz>
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
 <20130418101541.GC2672@localhost.localdomain>
 <20130418175513.GA12581@dhcp22.suse.cz>
 <20130419023345.GE2672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130419023345.GE2672@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Do not drop people from the CC please]

On Fri 19-04-13 10:33:45, Han Pingtian wrote:
> On Thu, Apr 18, 2013 at 10:55:14AM -0700, Michal Hocko wrote:
[...]
> > What is the kernel that you are using and what config?
> > 
> We are testing a alpha version of a enterprise linux which using a 3.7
> series kernel. On this 3.7 kernel we encountered the oom killer problem. So
> we decide to see if the problem can be reproduced on 3.9-rc7. We
> configured 3.9-rc7 by copying the enterprise linux's config file to
> .config and then run 'make localmodconfig' and pressed enter to all the
> questions. Then the oom problem is reproduced on the 3.9-rc7.
> 
> But we also used the same method to config 3.9-rc7 on another company's
> enterprise linux yesterday and found that the problem cannot be
> reproduced there. So maybe the leak is caused by some userspace
> applications?

No application should cause in-kernel mem leak. What is the difference
in the two configs?
-- 
Michal Hocko
SUSE Labs
