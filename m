Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaHaP1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 11:27:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:49229 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHaP1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 11:27:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,436,1406617200"; 
   d="scan'208";a="584231804"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 0/6] hugepage migration fixes (v3)
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Sun, 31 Aug 2014 08:27:35 -0700
In-Reply-To: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Thu, 28 Aug 2014 21:38:54 -0400")
Message-ID: <87tx4sk7bs.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> This is the ver.3 of hugepage migration fix patchset.

I wonder how far we are away from support THP migration with the
standard migrate_pages() syscall?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
