Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaB1S55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:57:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:21370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaB1S5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:57:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,563,1389772800"; 
   d="scan'208";a="464378969"
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/19 V2] perf, c2c: Add new tool to analyze cacheline contention on NUMA systems
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Date: Fri, 28 Feb 2014 10:57:48 -0800
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Fri, 28 Feb 2014 12:42:49 -0500")
Message-ID: <87wqgfawur.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:
>
> A handful of patches include re-enabling MMAP2 support and some fixes
> to perf itself.

I would suggest to pursue the lone kernel patch separately. Hopefully
that can be merged soon, once the remainin problems with that are 
addressed.

>
> Comemnts, feedback, anything else welcomed.

As a high level comment, can you add support for CSV mode? 
(-x, in other tools)

I assume most people would data mine the output in some form,
and that's much easier with a more machine oriented format.

Also you should probably have the standard perf conventions
for output fds (--log-fd, --output, default to stderr). otherwise
the output may often be lost.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
