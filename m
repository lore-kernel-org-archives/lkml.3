Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBFX6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:58:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:3357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaBFX6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:58:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,796,1384329600"; 
   d="scan'208";a="451038032"
From: Andi Kleen <andi@firstfloor.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 11/11] x86: perf: intel_bts: Add core dump related functionality
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1391683834-29868-12-git-send-email-alexander.shishkin@linux.intel.com>
Date: Thu, 06 Feb 2014 15:57:49 -0800
In-Reply-To: <1391683834-29868-12-git-send-email-alexander.shishkin@linux.intel.com>
	(Alexander Shishkin's message of "Thu, 6 Feb 2014 12:50:34 +0200")
Message-ID: <87mwi36bgi.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:

> BTS data can be used in process core dumps. This patch implements itrace
> core dump related hooks that will configure and output BTS traces into
> a core file.

Don't we need a different note number here? 

Otherwise how should the debugger know if it's BTS or PT.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
