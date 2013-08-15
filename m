Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3HOCYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 22:24:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:6299 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab3HOCYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 22:24:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,881,1367996400"; 
   d="scan'208";a="346589426"
Date: Wed, 14 Aug 2013 19:24:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Message-ID: <20130815022401.GQ23412@tassilo.jf.intel.com>
References: <520BB9EF.5020308@linux.intel.com>
 <20130815002436.GI6023@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815002436.GI6023@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And FWIW, it's no secret that XFS has more per-operation overhead
> than ext4 through the write path when it comes to allocation, so
> it's no surprise that on a workload that is highly dependent on
> allocation overhead that ext4 is a bit faster....

This cannot explain a worse scaling curve though?

w-i-s is all about scaling.

-Andi
