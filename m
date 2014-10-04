Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaJDNNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:13:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:55180 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaJDNNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="395495582"
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 12/17] mm: sys_remap_anon_pages
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
	<1412356087-16115-13-git-send-email-aarcange@redhat.com>
Date: Sat, 04 Oct 2014 06:13:27 -0700
In-Reply-To: <1412356087-16115-13-git-send-email-aarcange@redhat.com> (Andrea
	Arcangeli's message of "Fri, 3 Oct 2014 19:08:02 +0200")
Message-ID: <87iok0q8p4.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <aarcange@redhat.com> writes:

> This new syscall will move anon pages across vmas, atomically and
> without touching the vmas.
>
> It only works on non shared anonymous pages because those can be
> relocated without generating non linear anon_vmas in the rmap code.

...

> It is an alternative to mremap.

Why a new syscall? Couldn't mremap do this transparently?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
