Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab3JPAqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:46:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759792Ab3JPAqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:46:22 -0400
Message-ID: <525DE197.5040607@zytor.com>
Date: Tue, 15 Oct 2013 17:45:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v4 12/12] intel_mid: Moved board related code to a new
 file
References: <1381880568-20730-1-git-send-email-david.a.cohen@linux.intel.com> <1381880568-20730-13-git-send-email-david.a.cohen@linux.intel.com> <525DD362.4070807@zytor.com> <525DD571.20107@linux.intel.com>
In-Reply-To: <525DD571.20107@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 04:53 PM, David Cohen wrote:
> On 10/15/2013 04:44 PM, H. Peter Anvin wrote:
>> On 10/15/2013 04:42 PM, David Cohen wrote:
>>>
>>> +#define intel_mid_sfi_dev(i)   \
>>> +        static const struct devs_id *__intel_mid_sfi_##i##_dev __used \
>>> +        __attribute__((__section__(".x86_intel_mid_dev.init"))) = &i
>>> +
>>
>> Any reason to not just call this "sfi_device()" or something similar?
>> "Intel MID SFI" seems a bit redundant...
> 
> I had the same though. But struct devs_id is defined by asm/intel-mid.h.
> This function is not meant to be used by any other user beside
> intel-mid.
> But I can change if you prefer.
> 

Hm, I guess it doesn't really matter.  After all, no other devices will
probably ever see SFI (we hope).

	-hpa


