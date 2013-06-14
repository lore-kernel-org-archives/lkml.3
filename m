Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3FNFd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:33:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39412 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857Ab3FNFd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:33:27 -0400
Message-ID: <1371188006.31941.45.camel@joe-AO722>
Subject: Re: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to
 struct ctl_table
From: Joe Perches <joe@perches.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jiri Kosina <trivial@kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Date: Thu, 13 Jun 2013 22:33:26 -0700
In-Reply-To: <20130614052104.GX29338@dastard>
References: <cover.1371177118.git.joe@perches.com>
	 <1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
	 <20130614052104.GX29338@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 15:21 +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2013 at 07:37:50PM -0700, Joe Perches wrote:
> > This typedef is unnecessary and should just be removed.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Looks fine, Joe.
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>
> 
> How do you want us to handle this? Push it through the XFS tree or
> are you going to send it on up yourself?

Hi Dave.

I'd prefer you pick it up.

These are all pretty trivial patches, but Jiri
typically doesn't pick them up for months.

I expect I'll have to resend whatever maintainers
don't pick up in 6 months or so.


