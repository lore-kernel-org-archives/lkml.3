Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab3IFDlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:41:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:17951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758620Ab3IFDlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:41:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,851,1371106800"; 
   d="scan'208";a="291470152"
Date: Thu, 5 Sep 2013 20:41:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf mem: add priv level filtering support
Message-ID: <20130906034149.GM16724@tassilo.jf.intel.com>
References: <20130826131121.GA26224@quad>
 <521BD4F8.5050504@gmail.com>
 <20130828132703.GD3825@infradead.org>
 <CABPqkBTf8Ruoq1RZhLcBLkhJY1mzJLpnLsM0J_7Bz=9Eakeajg@mail.gmail.com>
 <20130828142112.GE3825@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828142112.GE3825@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But my worry here is about consistency accross tools for the single
> letter options, so perhaps if you could use:
> 
>      -U		collect only user level samples
>      -K		collect only kernel level samples

Support for this would be nice for perf stat too, to use with 
the implicit events (using by -d, soon -T etc.)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
