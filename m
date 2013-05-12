Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3ELAkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 20:40:35 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50874 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab3ELAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 20:40:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8RALPjjlF5LMBd/2dsb2JhbABagweDCrgmhSQEAX8XdIIfAQEFOhwjEAgDDgYECSUPBSUDIROIC7taFo11gR0HgnRhA5crihKHJIMhKg
Date: Sun, 12 May 2013 10:40:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130512004031.GE32675@dastard>
References: <20130507133707.GA18301@redhat.com>
 <87k3n5en0b.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3n5en0b.fsf@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 04:09:40PM +0400, Dmitry Monakhov wrote:
> On Tue, 7 May 2013 09:37:07 -0400, Dave Jones <davej@redhat.com> wrote:
> > started compiling a kernel, and then...
> > 
> I've bisected this one.
> commit 666d644cd72a9ec58b353209ff191d7430f3b357
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Apr 3 14:09:21 2013 +1100
> 
>     xfs: don't free EFIs before the EFDs are committed
> 
> #xfstests  ./check generic/007 generic/007 generic/007

Yuo, we already have a candidate fix for it. Thanks for another
independent confirmation of the cause, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
