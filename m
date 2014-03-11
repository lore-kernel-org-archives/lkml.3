Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCKLiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:38:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:45077 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbaCKLiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:38:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="470141371"
Message-ID: <531EF807.8080005@linux.intel.com>
Date: Tue, 11 Mar 2014 13:48:23 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Darren Hart <dvhart@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl-baytrail: add function mux checking in gpio pin
 request
References: <1394114389-27106-1-git-send-email-chiau.ee.chew@intel.com> <CACRpkdajaffBOmc9KeUyLkwZth6vNu-Z0Ln+Xf4ZV0gZ9Ytf_g@mail.gmail.com>
In-Reply-To: <CACRpkdajaffBOmc9KeUyLkwZth6vNu-Z0Ln+Xf4ZV0gZ9Ytf_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 12:27 PM, Linus Walleij wrote:
> On Thu, Mar 6, 2014 at 2:59 PM, Chew Chiau Ee <chiau.ee.chew@intel.com> wrote:
>
>> From: Chew, Kean Ho <kean.ho.chew@intel.com>
>>
>> The requested gpio pin must has the func_pin_mux field set
>> to GPIO function by BIOS/FW in advanced. Else, the gpio pin
>> request would fail. This is to ensure that we do not expose
>> any gpio pins which shall be used for alternate functions,
>> for eg: wakeup pin, I/O interfaces for LPSS, etc.
>>
>> Signed-off-by: Chew, Kean Ho <kean.ho.chew@intel.com>
>> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>
> Patch applied with Darren's ACK.
>
> This confirms my suspicion that you will not be able to
> hide the pin control interface side of this hardware forever. ;-)

Hate to admit it but so it seems :)

>
> Mika/Mathias: any comments?

Patch looks fine

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>

-Mathias
