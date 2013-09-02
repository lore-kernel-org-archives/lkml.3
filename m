Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3IBCum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:50:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:44437 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3IBCul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:50:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="372038067"
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf_event: rdpmc self-monitoring overhead issue
References: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
	<CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
Date: Sun, 01 Sep 2013 19:50:39 -0700
In-Reply-To: <CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
	(Stephane Eranian's message of "Fri, 30 Aug 2013 20:05:05 +0200")
Message-ID: <87ob8cdji8.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@googlemail.com> writes:

> I don't see a flag in mmap() to fault it in immediately.

MAP_PRESENT

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
