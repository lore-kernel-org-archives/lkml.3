Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3JNQaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:30:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:10269 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab3JNQaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="410704170"
Message-ID: <525C1CDE.9020309@linux.intel.com>
Date: Mon, 14 Oct 2013 09:33:34 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 08/10] intel_mid: Added custom handler for ipc devices
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com> <1381549404-22594-9-git-send-email-david.a.cohen@linux.intel.com> <525C1617.7090304@zytor.com>
In-Reply-To: <525C1617.7090304@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:04 AM, H. Peter Anvin wrote:
> On 10/11/2013 08:43 PM, David Cohen wrote:
>> +
>> +	/*
>> +	 * We need to call platform init of IPC devices to fill misc_pdata
>> +	 * structure. It will be used in msic_init for initialization.
>> +	 */
>> +	if (dev != NULL)
>> +		pdata = dev->get_platform_data(pentry);
>> +
>
> The Linux style usually prefers:
>
> 	if (dev)

Thanks. I'll change it on next patch set.

Br, David Cohen
