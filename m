Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab3KMRgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:36:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:47836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab3KMRga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:36:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434721675"
Message-ID: <5283B9AC.8010705@linux.intel.com>
Date: Wed, 13 Nov 2013 09:41:00 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] gpiolib: append SFI helpers for GPIO API
References: <1381979015-28980-1-git-send-email-david.a.cohen@linux.intel.com>  <1382013695.29062.141.camel@smile>  <CACRpkdZG=Sa92qGqK4Jt-L1AVRmremK5tgn8O5-5JccUsZDHTA@mail.gmail.com> <1384345006.14845.56.camel@smile>
In-Reply-To: <1384345006.14845.56.camel@smile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 04:16 AM, Andy Shevchenko wrote:
> On Tue, 2013-11-12 at 19:55 +0100, Linus Walleij wrote:
>> On Thu, Oct 17, 2013 at 2:41 PM, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>> On Wed, 2013-10-16 at 20:03 -0700, David Cohen wrote:
>>>> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>>>
>>>> To support some (legacy) firmwares and platforms let's make life easier for
>>>> their customers.
>>>
>>>> +int sfi_get_gpio_by_name(const char *name)
>>>> +{
>>>> +     struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
>>>> +     int i;
>>>> +
>>>> +     if (!pentry)
>>>> +             return -1;
>>>
>>> ^^^^ It seems an old version.
>>>
>>> New version was published while ago and even has an ACK from Linus:
>>>
>>> http://www.spinics.net/lists/kernel/msg1545960.html
>>
>> So what is happening to this thing?
>
> Actually David now coordinates work done for Medfield & Co.
> Perhaps he is not absent and could answer fast to this.
>
>> Is there some newer patch I should be merging?
>
> I'm pretty sure there is no newest version of patch.

Yeah, there is no newer version.
Linus, you're free to stick with the version pointed out by Andy on
this thread:
http://www.spinics.net/lists/kernel/msg1545960.html

Br, David
