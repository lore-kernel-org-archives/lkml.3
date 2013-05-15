Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3EOHaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:30:11 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:53658 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab3EOHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:30:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIPANI4k1F5LKxY/2dsb2JhbABagweDCrhOhRwEAXoXdIIfAQEFJxMcIxAIAw4KCSUPBSUDIROIC70IFo1rgR0Hg1UDlzORPoMhKg
Date: Wed, 15 May 2013 17:30:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, hughd@google.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 05/20] xfs: use ->invalidatepage() length argument
Message-ID: <20130515073004.GQ29466@dastard>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <1368549454-8930-6-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368549454-8930-6-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 06:37:19PM +0200, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in xfs_vm_invalidatepage()
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Ben Myers <bpm@sgi.com>
> Cc: xfs@oss.sgi.com

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
