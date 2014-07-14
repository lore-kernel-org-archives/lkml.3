Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaGNXwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 19:52:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:13932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaGNXwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 19:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,661,1400050800"; 
   d="scan'208";a="573117369"
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <53C1447D.1010809@intel.com>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
	 <1405110784.2970.655.camel@schen9-DESK>  <53C1447D.1010809@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jul 2014 16:51:21 -0700
Message-ID: <1405381881.2970.751.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 07:21 -0700, Tadeusz Struk wrote:
> On 07/11/2014 01:33 PM, Tim Chen wrote:
> > +unsigned long nr_running_cpu(int cpu)
> > +{
> > +	if (cpumask_test_cpu(cpu, cpu_online_mask))
> > +		return cpu_rq(cpu)->nr_running;
> > +	else
> > +		return 0;
> > +}
> > +
> EXPORT_SYMBOL?

Yes, thanks.

Tim

