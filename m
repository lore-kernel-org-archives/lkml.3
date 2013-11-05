Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3KEOQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:16:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:31129 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab3KEOQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:16:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="384903712"
Date: Tue, 5 Nov 2013 06:16:13 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
Message-ID: <20131105141613.GD1962@tassilo.jf.intel.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
 <1383231582-15856-3-git-send-email-eranian@google.com>
 <20131101105722.GA1088@krava.brq.redhat.com>
 <CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
 <20131104145110.GA2805@krava.brq.redhat.com>
 <CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any opinion?

Just don't show the unit if there is no unit.
That is what I asked for earlier.

-Andi
