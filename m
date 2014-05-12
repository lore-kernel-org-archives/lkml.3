Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaELDge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:36:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:65243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaELDgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="538662724"
From: Andi Kleen <andi@firstfloor.org>
To: Armin Rigo <arigo@tunes.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
Date: Sun, 11 May 2014 20:36:32 -0700
In-Reply-To: <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
	(Armin Rigo's message of "Thu, 8 May 2014 17:44:46 +0200")
Message-ID: <87tx8v4qin.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Armin Rigo <arigo@tunes.org> writes:

> Here is a note from the PyPy project (mentioned earlier in this
> thread, and at https://lwn.net/Articles/587923/ ).

Your use is completely bogus. remap_file_pages() pins everything 
and disables any swapping for the area.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
