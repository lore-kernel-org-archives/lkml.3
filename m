Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3GZLh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:37:28 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25336 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab3GZLhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:37:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgIAMFe8lF5LPxH/2dsb2JhbABagwa5F4UygRUXdIIkAQEFJxMcIxAIAxgJJQ8FJQMhE4gPuQsWj2cHhAUDl16RTYMmKg
Date: Fri, 26 Jul 2013 21:37:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: fix an assertion failure
Message-ID: <20130726113717.GN13468@dastard>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
 <20130726020318.GD21982@dastard>
 <CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:01:23PM +0800, Zhi Yong Wu wrote:
> No, it still raised the same assertion as below:
> 
> [  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
> XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940

How are you reproducing it?

Can you take an event trace with trace-cmd and attach the output of
the report?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
