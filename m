Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaDNWkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:40:46 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54292 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaDNWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:40:43 -0400
Date: Tue, 15 Apr 2014 00:40:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v4]
Message-ID: <20140414224042.GG22728@two.firstfloor.org>
References: <1396365545-12279-1-git-send-email-prarit@redhat.com>
 <20140414142914.57110976dd96134875b63639@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414142914.57110976dd96134875b63639@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let's not leak all those blacklist entries when we're finished?

It's difficult, because you cannot free bootmem after bootmem is
finished.

For the rare debug case some leaking should be acceptable.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
