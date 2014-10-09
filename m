Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbaJIN1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:27:00 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:52656 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaJIN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:26:55 -0400
Message-ID: <54368D16.40404@roeck-us.net>
Date: Thu, 09 Oct 2014 06:26:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "lguest@lists.ozlabs.org" <lguest@lists.ozlabs.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "linux-am33-list@redhat.com" <linux-am33-list@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
        "linux-metag@vger.kernel.org" <linux-metag@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 12/44] mfd: ab8500-sysctrl: Register with kernel poweroff
 handler
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-13-git-send-email-linux@roeck-us.net> <20141007080048.GB25331@lee--X1> <20141009103656.GF17836@e104818-lin.cambridge.arm.com> <20141009104927.GN20647@lee--X1>
In-Reply-To: <20141009104927.GN20647@lee--X1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54368D1F.0128,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 56
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 03:49 AM, Lee Jones wrote:
> On Thu, 09 Oct 2014, Catalin Marinas wrote:
>
>> On Tue, Oct 07, 2014 at 09:00:48AM +0100, Lee Jones wrote:
>>> On Mon, 06 Oct 2014, Guenter Roeck wrote:
>>>> --- a/drivers/mfd/ab8500-sysctrl.c
>>>> +++ b/drivers/mfd/ab8500-sysctrl.c
>>>> @@ -6,6 +6,7 @@
>>>
>>> [...]
>>>
>>>> +static int ab8500_power_off(struct notifier_block *this, unsigned long unused1,
>>>> +			    void *unused2)
>>>>   {
>>>>   	sigset_t old;
>>>>   	sigset_t all;
>>>> @@ -34,11 +36,6 @@ static void ab8500_power_off(void)
>>>>   	struct power_supply *psy;
>>>>   	int ret;
>>>>
>>>> -	if (sysctrl_dev == NULL) {
>>>> -		pr_err("%s: sysctrl not initialized\n", __func__);
>>>> -		return;
>>>> -	}
>>>
>>> Can you explain the purpose of this change please?
>>
>> I guess it's because the sysctrl_dev is already initialised when
>> registering the power_off handler, so there isn't a way to call the
>> above function with a NULL sysctrl_dev. Probably even with the original
>> code you didn't need this check (after some race fix in
>> ab8500_sysctrl_remove but races is one of the things Guenter's patches
>> try to address).
>
> Sounds reasonable, although I think this change should be part of
> another patch.
>
Sure, no problem. I'll split this into two patches.

Since we are at it, any idea what to do with the restart function
in the same file ? It is not used anywhere.

Guenter

