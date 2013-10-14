Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3JNQFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:05:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54575 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab3JNQFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:05:42 -0400
Message-ID: <525C1617.7090304@zytor.com>
Date: Mon, 14 Oct 2013 09:04:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 08/10] intel_mid: Added custom handler for ipc devices
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com> <1381549404-22594-9-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1381549404-22594-9-git-send-email-david.a.cohen@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 08:43 PM, David Cohen wrote:
> +
> +	/*
> +	 * We need to call platform init of IPC devices to fill misc_pdata
> +	 * structure. It will be used in msic_init for initialization.
> +	 */
> +	if (dev != NULL)
> +		pdata = dev->get_platform_data(pentry);
> +

The Linux style usually prefers:

	if (dev)
		...


	-hpa


