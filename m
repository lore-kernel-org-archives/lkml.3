Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3HUP47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:56:59 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51326 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3HUP46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:56:58 -0400
Date: Wed, 21 Aug 2013 10:56:54 -0500
From: Ben Myers <bpm@sgi.com>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: Dwight Engen <dwight.engen@oracle.com>, cbe-oss-dev@lists.ozlabs.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130821155654.GI5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
 <20130820120702.000b044e@oracle.com>
 <201308202246.30869.arnd@arndb.de>
 <20130821010822.220f592a@oracle.com>
 <52145E6C.80404@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52145E6C.80404@ozlabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dwight,

On Wed, Aug 21, 2013 at 02:30:04PM +0800, Jeremy Kerr wrote:
> > Yes, I agree. The other filesystems that take an Opt_uid as well do use
> > current_user_ns() and not init_user_ns. They also do a uid_valid()
> > check and fail the mount (or fallback to GLOBAL_ROOT_UID). So I think
> > that would look like this:
> 
> Looks good to me. Builds and mounts as expected.
> 
> Acked-by: Jeremy Kerr <jk@ozlabs.org>

Could you repost this patch with the right subject and a commit header?  Given
Jeremy's Ack I think we could proceed to pull this in.

Regards,
	Ben
