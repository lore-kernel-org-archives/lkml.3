Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaHONjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:39:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:36795 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaHONjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:39:54 -0400
Date: Fri, 15 Aug 2014 10:39:50 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Alex Converse <aconverse@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf annotate: Don't truncate Intel style addresses
Message-ID: <20140815133950.GB3508@kernel.org>
References: <1408050180-14088-1-git-send-email-aconverse@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408050180-14088-1-git-send-email-aconverse@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 14, 2014 at 02:03:00PM -0700, Alex Converse escreveu:
> Instructions like "mov r9,QWORD PTR [rdx+0x8]" were being truncated to
> "mov r9,QWORD" by code that assuemd operands cannot have spaces.
> 
> Signed-off-by: Alex Converse <aconverse@google.com>

Thanks, applied.

- Arnaldo
