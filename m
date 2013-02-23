Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3BWANf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:13:35 -0500
Received: from two.firstfloor.org ([193.170.194.197]:35861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3BWANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:13:34 -0500
Date: Sat, 23 Feb 2013 01:13:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
Message-ID: <20130223001332.GA30494@two.firstfloor.org>
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
 <20130221233818.GM26694@dastard>
 <m2bobdxl1i.fsf@firstfloor.org>
 <5126F067.4040707@hp.com>
 <20130222230048.GP26694@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222230048.GP26694@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That seems to me like an application problem - poking at what the
> kernel is doing via diagnostic interfaces so often that it gets in
> the way of the kernel actually doing stuff is not a problem the
> kernel can solve.

I agree with you that the application shouldn't be doing that, but 
if there is a cheap way to lower the d_path overhead that is also
attractive.  There will be always applications doing broken things.
Any scaling problem less in the kernel is good.

But the real fix in this case is to fix the application.

-Andi
