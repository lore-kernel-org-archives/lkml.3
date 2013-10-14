Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3JNQgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:36:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:44986 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669Ab3JNQgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="392764002"
Message-ID: <525C1E6D.1040009@linux.intel.com>
Date: Mon, 14 Oct 2013 09:40:13 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Joe Perches <joe@perches.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 07/10] intel_mid: Added custom device_handler support
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com>  <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>  <525C15E8.9010201@zytor.com> <1381767415.25528.10.camel@joe-AO722> <525C1CBB.9030708@linux.intel.com> <525C1C42.5010805@zytor.com>
In-Reply-To: <525C1C42.5010805@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:30 AM, H. Peter Anvin wrote:
> On 10/14/2013 09:32 AM, David Cohen wrote:
>>
>> Thanks for your feedback. The parameters happen to be similar at this
>> time, but they won't be after next patches. I believe a macro could
>> remove only prefix 'SFI_DEV_TYPE_' and suffix '_platform_data', which
>> seems enough to reduce line size.
>>
>
> That seems like unnecessary obfuscation.

OK. In this case I'll let line > 80 for better readability as you
suggested before.

Br, David Cohen

>
> 	-hpa
>
>

