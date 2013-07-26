Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab3GZLwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:52:02 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43326 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553Ab3GZLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:51:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIXAHxi8lF5LPxH/2dsb2JhbABagwa5F4UygRUXdASCIAEBBTocIxAIAxgJJQ8FJQMhE4gPuREWj2cHhAUDl16KIocrgyYq
Date: Fri, 26 Jul 2013 21:51:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V8 27/33] xfs: add support for read_iter and write_iter
Message-ID: <20130726115136.GP13468@dastard>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <1374774659-13121-28-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374774659-13121-28-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:50:53PM -0500, Dave Kleikamp wrote:
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

Looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
