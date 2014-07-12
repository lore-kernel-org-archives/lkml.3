Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaGLOZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 10:25:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:17385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaGLOZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 10:25:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,649,1400050800"; 
   d="scan'208";a="456236302"
Message-ID: <53C1447D.1010809@intel.com>
Date: Sat, 12 Jul 2014 07:21:49 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose number
 of tasks running on cpu
References: <cover.1405074379.git.tim.c.chen@linux.intel.com> <1405110784.2970.655.camel@schen9-DESK>
In-Reply-To: <1405110784.2970.655.camel@schen9-DESK>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 01:33 PM, Tim Chen wrote:
> +unsigned long nr_running_cpu(int cpu)
> +{
> +	if (cpumask_test_cpu(cpu, cpu_online_mask))
> +		return cpu_rq(cpu)->nr_running;
> +	else
> +		return 0;
> +}
> +
EXPORT_SYMBOL?
