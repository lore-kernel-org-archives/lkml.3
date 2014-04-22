Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaDVHFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:05:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbaDVHFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:05:43 -0400
Date: Tue, 22 Apr 2014 08:10:57 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
Message-ID: <20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
References: <cover.1395840483.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1395840483.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 02:34:22PM +0100, Alexander Gordeev wrote:
> But other systems (more dense?) showed increased cache-hit rate
> up to 20%, i.e. this one:

Hello Gentlemen,

Any feedback on this?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
