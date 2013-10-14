Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3JNQcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:32:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab3JNQca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:32:30 -0400
Message-ID: <525C1C42.5010805@zytor.com>
Date: Mon, 14 Oct 2013 09:30:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, Joe Perches <joe@perches.com>
CC: tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 07/10] intel_mid: Added custom device_handler support
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com>  <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>  <525C15E8.9010201@zytor.com> <1381767415.25528.10.camel@joe-AO722> <525C1CBB.9030708@linux.intel.com>
In-Reply-To: <525C1CBB.9030708@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:32 AM, David Cohen wrote:
> 
> Thanks for your feedback. The parameters happen to be similar at this
> time, but they won't be after next patches. I believe a macro could
> remove only prefix 'SFI_DEV_TYPE_' and suffix '_platform_data', which
> seems enough to reduce line size.
> 

That seems like unnecessary obfuscation.

	-hpa


