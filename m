Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3BURCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:02:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:61942 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3BURCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:02:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,710,1355126400"; 
   d="scan'208";a="204961411"
Message-ID: <51265309.6040605@linux.intel.com>
Date: Thu, 21 Feb 2013 09:02:01 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de, walt0924@gmail.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi: Make "noefi" really disable EFI runtime
 serivces
References: <1361392572-25657-1-git-send-email-matt@console-pimps.org>  <tip-fb834c7acc5e140cf4f9e86da93a66de8c0514da@git.kernel.org>  <CAE9FiQWnaGzDEko=sCzvT8LS7heZ7miwiVU+T4eJk-JgSr_Z4w@mail.gmail.com> <1361442806.2842.2.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1361442806.2842.2.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:33 AM, Matt Fleming wrote:
> On Wed, 2013-02-20 at 16:16 -0800, Yinghai Lu wrote:
>>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>>> index 928bf83..e2cd38f 100644
>>> --- a/arch/x86/platform/efi/efi.c
>>> +++ b/arch/x86/platform/efi/efi.c
>>> @@ -85,9 +85,10 @@ int efi_enabled(int facility)
>>>  }
>>>  EXPORT_SYMBOL(efi_enabled);
>>>
>>> +static bool disable_runtime = false;
>>
>> __initdata please.
> 
> Sure. Peter, please drop this. I'll submit a v2.
> 

Just do an incremental, please.

	-hpa

