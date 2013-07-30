Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3G3D5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:57:53 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8191 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab3G3D5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:57:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFAKg491F5LPxHgWdsb2JhbABbgzuCd7YyhTKBHhcOAQEWJiiCJAEBBTocIxAIAxgJJQ8FJQMhE4gPDbh+Fo0QgSKBNgeEBwOXXooiiQaBSyqBLQ
Date: Tue, 30 Jul 2013 13:57:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: dwight.engen@oracle.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
 projids in any user namespace
Message-ID: <20130730035748.GJ21982@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-5-git-send-email-ebiederm@xmission.com>
 <20130219015550.GJ26694@dastard>
 <51F616F2.5040906@cn.fujitsu.com>
 <20130729075109.GF13468@dastard>
 <51F72FE6.4080202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F72FE6.4080202@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:15:50AM +0800, Gao feng wrote:
> On 07/29/2013 03:51 PM, Dave Chinner wrote:
> > http://oss.sgi.com/pipermail/xfs/2013-July/028467.html
> > 
> > Basically, the discussion we are currently having is whether project
> > IDs should be exposed to user namespaces at all. e.g:
> > 
> > http://oss.sgi.com/pipermail/xfs/2013-July/028497.html
> > http://oss.sgi.com/pipermail/xfs/2013-July/028551.html
> > 
> > "Basically, until we have worked out *if* project quotas can be used
> > safely within user namespaces, we need to reject any attempt to use
> > them from within a user namespace container."
> > 
> 
> yes, seems this v6 patchset allows user in un-init user namespace to setup proj quota
> through ioctl, and the projid hasn't been converted to kprojid in this patchset.
> Doesn't this will cause user in container has the ability to change the proj quota
> which is set by root user in host?

Dwight just posted v7. can you discuss your concerns in reposnse to
the relevant patch in that series, please? it's much easier for
everyone if we keep the discussion int eh one thread ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
