Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3LFSWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:22:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:3326 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab3LFSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:22:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="420587502"
From: Andi Kleen <andi@firstfloor.org>
To: Lans Zhang <jia.zhang@windriver.com>
Cc: <mingo@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mm/numa: fix becoming single node on numa machine with 32-bit kernel.
References: <1386303510-18574-1-git-send-email-jia.zhang@windriver.com>
Date: Fri, 06 Dec 2013 10:22:54 -0800
In-Reply-To: <1386303510-18574-1-git-send-email-jia.zhang@windriver.com> (Lans
	Zhang's message of "Fri, 6 Dec 2013 12:18:30 +0800")
Message-ID: <87wqjhvny9.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lans Zhang <jia.zhang@windriver.com> writes:
>
> Signed-off-by: Lans Zhang <jia.zhang@windriver.com>

Patch looks good to me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
