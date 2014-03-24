Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaCXTyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:54:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:32937 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbaCXTye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:54:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,722,1389772800"; 
   d="scan'208";a="505706794"
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 4/6] perf, sort:  Add physid sorting based on mmap2 data
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
	<1395689676-214799-5-git-send-email-dzickus@redhat.com>
Date: Mon, 24 Mar 2014 12:54:31 -0700
In-Reply-To: <1395689676-214799-5-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:34:34 -0400")
Message-ID: <8761n3pe2w.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> In order for the c2c tool to work correctly, it needs to properly
> sort all the records on uniquely identifiable data addresses.  These
> unique addresses are converted from virtual addresses provided by the
> hardware into a kernel address using an mmap2 record as the decoder.

No documentation for the new option?

Probably the new mode should be also supported by --sort

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
