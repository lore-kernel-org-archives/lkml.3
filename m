Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3DXBms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:42:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52386 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3DXBmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:42:45 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-81-5177389033c0
Date: Wed, 24 Apr 2013 10:42:40 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 6/6] add documentation on proc.txt
Message-ID: <20130424014240.GA17222@blaptop>
References: <1366620306-30940-1-git-send-email-minchan@kernel.org>
 <1366620306-30940-6-git-send-email-minchan@kernel.org>
 <51756286.4020704@intel.com>
 <20130423015349.GC2603@blaptop>
 <51769BD1.7070002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51769BD1.7070002@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Tue, Apr 23, 2013 at 07:33:53AM -0700, Dave Hansen wrote:
> On 04/22/2013 06:53 PM, Minchan Kim wrote:
> > echo 'file' > /proc/PID/reclaim
> > echo 'anon' > /proc/PID/reclaim
> > echo 'both' > /proc/PID/reclaim
> > 
> > For range reclaim,
> > 
> > echo $((1<<20)) 8192 > /proc/PID/reclaim.
> > 
> > IOW, we don't need any type for range reclaim because only thing
> > user takes care is address range which has mapped page regardless
> > of that it's anon or file.
> > 
> > Does it make sense to you?
> 
> That looks very nice!  Although, I'd probably use 'all' instead of
> 'both'.  It leaves you more wiggle room to add more types in the future,
> like volatile pages.

Fair enough.
Thanks for the review.
I just sent a new. 

-- 
Kind regards,
Minchan Kim
