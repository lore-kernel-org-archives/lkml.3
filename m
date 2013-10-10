Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3JJTrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:47:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47596 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab3JJTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:47:49 -0400
Date: Thu, 10 Oct 2013 21:47:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/34] dynamically allocate split ptl if it cannot be
 embedded to struct page
Message-ID: <20131010194744.GU13848@laptop.programming.kicks-ass.net>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:05:25PM +0300, Kirill A. Shutemov wrote:
> Any comments?

Reviewed-by: Peter Zijlstra <peterz@infradead.org>
