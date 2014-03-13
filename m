Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaCMXps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:45:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51337 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaCMXpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:45:24 -0400
X-AuditID: 9c93016f-b7b09ae000000557-16-53224311fa87
Date: Fri, 14 Mar 2014 08:45:21 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-ID: <20140313234521.GA2479@lge.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
 <20140313024617.GA4900@lge.com>
 <20140313134035.5362a0b51b0a3c280ddc7667@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313134035.5362a0b51b0a3c280ddc7667@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 01:40:35PM -0700, Andrew Morton wrote:
> On Thu, 13 Mar 2014 11:46:17 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Hello, Andrew.
> > 
> > I applied all your comments in below patch. :)
> 
> OK, thanks.  I'll grab this instead of v5 - I wasn't thinking very
> clearly with the lock hold time issue.  Let's go for low latency then
> worry about it later if this function starts showing on profiles.

Okay.

> 
> I modified your code comments somewhat - please check.
>

All changes looks good!
Thanks for fixing it.

Thanks.

