Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaAOXXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:23:51 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64667 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaAOXXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:23:49 -0500
Date: Wed, 15 Jan 2014 18:23:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Eric Paris <eparis@redhat.com>
Cc: David Miller <davem@davemloft.net>, jkaluza@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rgb@redhat.com,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
Message-ID: <20140115232345.GA22237@mtj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
 <20140115.121730.1984913330507219167.davem@davemloft.net>
 <1389828103.681.34.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389828103.681.34.camel@flatline.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:21:43PM -0500, Eric Paris wrote:
> Reliably being able to audit what process requested an action is
> extremely useful.  And I like the audit patch, as it is a couple of ints
> we are storing.
> 
> procinfo and cgroup can both be up to 4k of data.
> 
> Is there an alternative he should consider?  Some way to grab a
> reference on task_struct and just attach that to the message?

Or maybe it can be made separately optional instead of tagging along
on an existing option so that it doesn't tax use cases which don't
care about the new stuff?

Thanks.

-- 
tejun
