Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3AUP6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:58:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:64007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3AUP6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:58:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,507,1355126400"; 
   d="scan'208";a="274707248"
Message-ID: <50FD65A8.2030600@linux.intel.com>
Date: Mon, 21 Jan 2013 09:58:32 -0600
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] x86: Add cpu capability flag X86_FEATURE_TSC_S3_NOTSTOP
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <1358750325-21217-2-git-send-email-feng.tang@intel.com> <20130121072729.GB11915@gchen.bj.intel.com> <20130121075900.GA509@feng-snb>
In-Reply-To: <20130121075900.GA509@feng-snb>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 01:59 AM, Feng Tang wrote:
>>>  
>> We have an existed "TSC always running in C3+" feature and name it as
>> X86_FEATURE_NONSTOP_TSC, so how about naming it with the same style,
>> like X86_FEATURE_NONSTOP_TSC_S3?
> 
> Yeah, actually I used a name X86_FEATURE_xxx_TSC, then I did a grep,
> and found there is no unified name convention for TSC, so I chose such
> a name.
> 

I think NONSTOP_TSC_S3 is quite a bit more consistent than S3_NOTSTOP...

	-hpa


