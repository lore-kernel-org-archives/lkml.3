Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbaGDDQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:16:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49150 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaGDDQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:16:36 -0400
Date: Fri, 4 Jul 2014 05:16:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DNAME_INLINE_LEN versus CONFIG_GENERIC_LOCKBREAK
Message-ID: <20140704031633.GT5714@two.firstfloor.org>
References: <8761je94wk.fsf@rasmusvillemoes.dk>
 <87fviite1u.fsf@tassilo.jf.intel.com>
 <20140704013222.GH9508@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704013222.GH9508@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IF you've turned on debugging options, then you've already lost more
> performance that careful packing of the dentry slab cache gains you.
> There's no point in carefully tuning DNAME_INLINE_LEN for debug
> options - it's just code that will break and annoy people as debug
> implementations change.

lockbreak is not a debug option.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
