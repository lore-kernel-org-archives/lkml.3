Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3CTPlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:41:36 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:42763 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab3CTPle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:41:34 -0400
Message-ID: <5149D8AB.7020101@slimlogic.co.uk>
Date: Wed, 20 Mar 2013 15:41:31 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Grant Likely <grant.likely@secretlab.ca>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree relatred)
References: <20130306114452.a041ab0737783f9730c1486e@canb.auug.org.au> <CACxGe6sZKRjSnwa-CHC1OhJoGP-ZQe4H2YbMYjDjNYcSdSyuow@mail.gmail.com> <20130321022524.37baf9fedb1848cdbdfc0eef@canb.auug.org.au>
In-Reply-To: <20130321022524.37baf9fedb1848cdbdfc0eef@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/13 15:25, Stephen Rothwell wrote:
> Hi Grant,
>
> On Wed, 6 Mar 2013 09:10:42 +0800 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> On Wed, Mar 6, 2013 at 8:44 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> After merging the final tree, today's linux-next build (powerpc
>>> allyesconfig) failed like this:
>>>
>>> drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_probe':
>>> drivers/gpio/gpio-palmas.c:173:2: error: implicit declaration of function 'is_palmas_charger' [-Werror=implicit-function-declaration]
>>> drivers/gpio/gpio-palmas.c:173:30: error: 'struct palmas' has no member named 'product_id'
>>>
>>> Caused by commit 82d4d6637fdf ("gpio/palmas: add in GPIO support for
>>> palmas charger").  I wonder if this was ever build tested. :-(
>>
>> Probably not. Looks like this driver doesn't get enabled without the
>> associated option in MFD. I didn't go searching for it, so my build
>> tests didn't catch it. I'll drop the patch from my tree. Sorry for the
>> pain.
>
> I am still having to revert this commit ....  :-(
>

Sorry Stephen  - There's a new patch series, that should resolve this, 
undergoing review at the moment so that patch should be reverted...
for now.


Regards,

Ian
