Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967869Ab3DSCpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 22:45:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:41385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967790Ab3DSCpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:45:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,505,1363158000"; 
   d="scan'208";a="321484441"
Message-ID: <5170AFAC.9050602@linux.intel.com>
Date: Thu, 18 Apr 2013 19:45:00 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: zhang.yi20@zte.com.cn
CC: Dave Hansen <dave@sr71.net>, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
References: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn> <516EAF31.8000107@linux.intel.com> <516EBF23.2090600@sr71.net> <516EC508.6070200@linux.intel.com> <OF7B3DF162.973A9AD7-ON48257B51.00299512-48257B51.002C7D65@zte.com.cn> <51700475.7050102@linux.intel.com> <OFD8FA3C9D.ACFCFB28-ON48257B52.0008A691-48257B52.000C4DFB@zte.com.cn>
In-Reply-To: <OFD8FA3C9D.ACFCFB28-ON48257B52.0008A691-48257B52.000C4DFB@zte.com.cn>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> BTW, have you seen the testcase in my other mail?  It seems to be rejected 
> by LKML.
> 

I did not receive it, did you also CC me?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
