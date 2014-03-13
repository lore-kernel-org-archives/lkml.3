Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaCMUvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:51:55 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63481 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaCMUvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <CACz4_2eYUOkHdOtBJGDGMMwBcQkyPs8BDXQ491Ab_ig4z8q5mQ@mail.gmail.com>
References: <1393625931-2858-1-git-send-email-quning@google.com> <CACz4_2eYUOkHdOtBJGDGMMwBcQkyPs8BDXQ491Ab_ig4z8q5mQ@mail.gmail.com>
From: Ning Qu <quning@google.com>
Date: Thu, 13 Mar 2014 13:46:04 -0700
Message-ID: <CACz4_2fD=GErMJB3+NJFfhdV_vmPeWTg17J+KOGw17BLN9dBTQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm, shmem: map few pages around fault address if they
 are in page cache
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ning Qu <quning@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

I have updated the results for tmpfs last week and Hugh already ack
this patchset on Mar 4 in "[PATCH 1/1] mm: implement ->map_pages for
shmem/tmpfs"

Acked-by: Hugh Dickins <hughd@google.com>

Please consider to apply this patch so that tmpfs will have the
similar feature together with the other file systems. Thanks a lot!

Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066
