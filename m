Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab3G2CqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:46:10 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12425 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab3G2CqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:46:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcGAAXX9VF5LPxH/2dsb2JhbABbgwa5JoUygRQXdIIkAQEFOhwjEAgDGAklDwUlAyETiA+3RBaOOoEtB4MWbwOXXpFNgyYqgS0
Date: Mon, 29 Jul 2013 12:45:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: introduce object readahead to log recovery
Message-ID: <20130729024546.GD13468@dastard>
References: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
 <20130726025009.GE21982@dastard>
 <CAEH94Lh-UCCEs7hQi_t5v+X+ER1DH9dCtjr6e9GVNX5KJ-f1hQ@mail.gmail.com>
 <20130726113521.GM13468@dastard>
 <CAEH94Ljpih875VOEdCY9Z9CdMF_1DesW7dsz_k7Zm=xt165w5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94Ljpih875VOEdCY9Z9CdMF_1DesW7dsz_k7Zm=xt165w5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 09:38:11AM +0800, Zhi Yong Wu wrote:
> By the way, how do you try the workload which has nothing but dirty
> dquote objects?

Create quota limits for non-existent users. That will allocate the
dquots and dirty them.

Or if you already have a few hundred thousand dquots, just change
the limits on them all to get them logged and dirty...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
