Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaACDWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:22:11 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59611 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaACDWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140102155726.GA865@suse.de>
References: <1388661922-10957-1-git-send-email-sj38.park@gmail.com> <20140102155726.GA865@suse.de>
From: SeongJae Park <sj38.park@gmail.com>
Date: Fri, 3 Jan 2014 12:21:47 +0900
Message-ID: <CAEjAshoYE=c_bfOAuR+0eP0No6PErFvSm9dDmrZ=RnXQPWW9fQ@mail.gmail.com>
Subject: Re: [PATCH] mm: page_alloc: use enum instead of number for migratetype
To: Mel Gorman <mgorman@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 12:57 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Thu, Jan 02, 2014 at 08:25:22PM +0900, SeongJae Park wrote:
>> Using enum instead of number for migratetype everywhere would be better
>> for reading and understanding.
>>
>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>
> This implicitly makes assumptions about the value of MIGRATE_UNMOVABLE
> and does not appear to actually fix or improve anything.
>
> --
> Mel Gorman
> SUSE Labs

I thought the implicit assumptions may be helpful for some kind of
people's readability.
But, anyway, I agree and respect your opinion now.

Thanks and Regards.
SeongJae Park
