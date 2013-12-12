Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3LLMqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:46:33 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59890 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3LLMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:46:29 -0500
Date: Thu, 12 Dec 2013 13:46:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131212124626.GA5806@gmail.com>
References: <1386841541-32244-1-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386841541-32244-1-git-send-email-andrzej.p@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrzej Pietrasiewicz <andrzej.p@samsung.com> wrote:

> Use list_first_entry instead of explicitly accessing the first entry
> with "head".next. The comment one line above becomes obsolete.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <andrzej.p@samsung.com>

that signoff sequence looks bogus - the first SOB should be the 
author, the last SOB the person sending the patch. If you want to 
credit someone please do it elsewhere in the changelog.

Thanks,

	Ingo
