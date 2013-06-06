Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3FFIYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:24:35 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:56125 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3FFIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:24:31 -0400
Message-ID: <51B04739.8020005@atmel.com>
Date: Thu, 6 Jun 2013 10:24:25 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        "Fabio Porcedda" <fabio.porcedda@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <manabian@gmail.com>, <laurent.navet@gmail.com>
Subject: Re: [PATCH v2 0/7] pcmcia: at91_cf: clean up and add DT support
References: <cover.1363865228.git.nicolas.ferre@atmel.com> <CAHkwnC-aL=G9K9jttjD8Bk_ZKJ535vsGT26uCFbuFMeJUquYQw@mail.gmail.com> <516E628B.1000104@atmel.com> <20130419225448.GA8242@kroah.com> <51AF0D2A.2@atmel.com> <20130605192240.GA5647@kroah.com>
In-Reply-To: <20130605192240.GA5647@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 21:22, Greg Kroah-Hartman :
> On Wed, Jun 05, 2013 at 12:04:26PM +0200, Nicolas Ferre wrote:
>> On 20/04/2013 00:54, Greg Kroah-Hartman :
>>> On Wed, Apr 17, 2013 at 10:51:23AM +0200, Nicolas Ferre wrote:
>>>> On 04/17/2013 10:39 AM, Fabio Porcedda :
>>>>> On Thu, Mar 21, 2013 at 12:40 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>>>>>> These patches clean up at91_cf a bit and add DT bindings.
>>>>>> It is based on a previous series from Joachim Eastwood and other cleanup
>>>>>> patches by Fabio and Laurent.
>>>>>> I have collected them together as they are lying around for some time.
>>>>>>
>>>>>> Please tell me if It can go through PCMCIA tree or if Andrew or Greg can
>>>>>> take them.
>>>>>> Note that they are not bug fixes, so you can stack them for 3.10.
>>>>>>
>>>>>> Thanks for your help, best regards.
>>>>>>
>>>>>> v2: add 2 more cleanup patches:
>>>>>>          - move to module_platform_driver_probe()
>>>>>>          - little trivial indentation fix
>>>>>>
>>>>>> Fabio Porcedda (1):
>>>>>>    pcmcia: at91_cf: use module_platform_driver_probe()
>>>>>>
>>>>>> Joachim Eastwood (5):
>>>>>>    pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
>>>>>>    pcmcia: at91_cf: convert to dev_ print functions
>>>>>>    pcmcia: at91_cf: use devm_ functions for allocations
>>>>>>    pcmcia: at91_cf: clean up header includes
>>>>>>    pcmcia: at91_cf: add support for DT
>>>>>>
>>>>>> Laurent Navet (1):
>>>>>>    pcmcia/trivial: at91_cf: fix checkpatch error
>>>>>>
>>>>>>   .../devicetree/bindings/ata/atmel-at91_cf.txt      |  19 +++
>>>>>>   drivers/pcmcia/Kconfig                             |   2 +-
>>>>>>   drivers/pcmcia/at91_cf.c                           | 176 ++++++++++-----------
>>>>>>   3 files changed, 108 insertions(+), 89 deletions(-)
>>>>>>   create mode 100644 Documentation/devicetree/bindings/ata/atmel-at91_cf.txt
>>>>>>
>>>>>> --
>>>>>> 1.8.0
>>>>>>
>>>>>
>>>>> Ping?
>>>>
>>>> Andrew, Greg, can you please take this series?
>>>>
>>>> Here is the post on lkml:
>>>> https://lkml.org/lkml/2013/3/21/246
>>>>
>>>> Here is the first patch in patchwork (1/7):
>>>> https://patchwork.kernel.org/patch/2312691/
>>>>
>>>> Tell me if I can do something else to make this applied upstream...
>>>
>>> The PCMCIA maintainer should take these, not me.
>>
>> I know Greg, but this patch series is still not taken by anyone 3
>> months after its first submission and after several requests by both
>> Fabio and myself...
>>
>> The series is still applying on linux-next today... Maybe it can go
>> via Andrew, then...
>
> I can take them through my char/misc driver tree if it's been that long
> of a delay, care to resend them to me?

Yep, I do it right now. Thanks a lot Greg.

Best regards,
-- 
Nicolas Ferre
