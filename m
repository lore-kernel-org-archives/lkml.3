Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaBGJDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:03:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:49836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaBGJDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:03:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,799,1384329600"; 
   d="scan'208";a="479508200"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 11/11] x86: perf: intel_bts: Add core dump related functionality
In-Reply-To: <87mwi36bgi.fsf@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-12-git-send-email-alexander.shishkin@linux.intel.com> <87mwi36bgi.fsf@tassilo.jf.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Feb 2014 11:02:59 +0200
Message-ID: <87r47fl2gs.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:
>
>> BTS data can be used in process core dumps. This patch implements itrace
>> core dump related hooks that will configure and output BTS traces into
>> a core file.
>
> Don't we need a different note number here? 
>
> Otherwise how should the debugger know if it's BTS or PT.

The pmu name is part of the note as well as its itrace_config.

Regards,
--
Alex
