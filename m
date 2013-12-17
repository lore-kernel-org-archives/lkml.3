Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3LQHSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:18:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47775 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab3LQHSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:18:04 -0500
From: "Gupta, Pekon" <pekon@ti.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Huang Shijie <b32955@freescale.com>,
        "mike@steroidmicros.com" <mike@steroidmicros.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "marex@denx.de" <marex@denx.de>,
        "Poddar, Sourav" <sourav.poddar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "b44548@freescale.com" <b44548@freescale.com>,
        "b18965@freescale.com" <b18965@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v3 0/7] mtd: spi-nor: add a new framework for SPI NOR
Thread-Topic: [PATCH v3 0/7] mtd: spi-nor: add a new framework for SPI NOR
Thread-Index: AQHO+kEsaFhlxdv/G0izx3HVzQkpD5pXxNWA//96EoCAAI+e8P//k2oAgACTohA=
Date: Tue, 17 Dec 2013 07:17:01 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EA56C5B@DBDE04.ent.ti.com>
References: <1387184330-14448-1-git-send-email-b32955@freescale.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA56ADC@DBDE04.ent.ti.com>
 <20131217040209.GA27091@shlinux2.ap.freescale.net>
 <20980858CB6D3A4BAE95CA194937D5E73EA56B3A@DBDE04.ent.ti.com>
 <20131217060731.GJ6691@S2101-09.ap.freescale.net>
In-Reply-To: <20131217060731.GJ6691@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

>From: Shawn Guo [mailto:shawn.guo@linaro.org]
>>On Tue, Dec 17, 2013 at 05:00:53AM +0000, Gupta, Pekon wrote:
>> >From: Huang Shijie [mailto:b32955@freescale.com]
>>> >On Tue, Dec 17, 2013 at 04:08:33AM +0000, Gupta, Pekon wrote:
[...]

>> >> As much base code is copied from m25p90.c,
>> >> Do you mind keeping the sign-offs of the original contributors of m25p80.c
>> >> at-least in patches where much code is ported ?
>> >I have added the lines in the spi-nor.c:
>> >
>> > " Cloned most of the code from the m25p80.c"
>> >
>> >> This would at-least give some credit to original authors and contributors.
>> >I do not change any authors information of m25p80.c.
>> >
>> >If it is not enough?  Could you remind me what to do ?
>
>In case you clone most of the code from m25p80.c, you need to keep the
>copyright of that file as well, and add yours on top of it.
>
Agree...


>> >
>> (1) Add sign-offs of main authors of m25p80, so that original contributors
>>  still remains in path of submission [1].
>
>The sign-off shouldn't be added by anyone than the person himself.  The
>sign-off tag is generally used in the following cases as far as I know.
>
>1. When the patch is authored, the author A should surely add his
>   sign-off in the first place.
>
>2. If person B submits A's patch with some or without any change on the
>   patch, B should add his sign-off.
>
>3. Maintainer C should add his sign-off when he applies the patch.
>
>In any case, one's sign-off shouldn't be added anyone but himself.
>I do not see the need to add sign-off of m25p80 authors at the current
>situation.
>
Agree..
So I meant sign-off with permission from the original authors themselves.
And Sign-offs can be multiple (but with permission of-course).
OR, you can ask the original author to sign-off for you..


>>
>> (2) Also, please remove following from spi-nor.c
>>   However, you can keep this in fsl-quadspi.c.
>>   +MODULE_AUTHOR("Freescale Semiconductor Inc.");
>>   I'm sure this was _not_ present in original m25p80.c
>>  (m25p80.c was started as ST's driver as per MODULE_DESCRIPTION)
>
>Are you talking about drivers/mtd/devices/m25p80.c?  If so, I'm seeing
>the following lines in the file.
>
>MODULE_LICENSE("GPL");
>MODULE_AUTHOR("Mike Lavender");
>MODULE_DESCRIPTION("MTD SPI driver for ST M25Pxx flash chips");
>
>I think we should keep the original MODULE_LICENSE and MODULE_AUTHOR,
>add a new MODULE_AUTHOR("Huang Shijie <b32955@freescale.com>") line,
>and update MODULE_DESCRIPTION line properly.
>
As indicated in previous thread also,
if the engineer's association with the company is broken then the email-id
in MODULE_AUTHOR becomes invalid. Hence to keep long term tractability
of the developer I suggested to use 'personal mail-id' here.
MODULE_AUTHOR should have a email-id which is valid for long term, because
you might need to at-least loop-in Author in longer time when there are some
bug-fix or considerable code change.
(This problem was also pointed out earlier in one of the emails by greg-kh,
 But I'm unable to trace that now).


>>
>> (3)     +MODULE_LICENSE("GPL");
>> Also, I assume the license version should be "GPLv2" ?
>
>If this is from original m25p80.c, we shouldn't change it, IMO.
>
As I can understand from general threads on google.
GPLv2 gives some additional protection to free-software companies from
patent litigations of proprietary software companies. As this code is not
exact replica of m25p80.c, so it should be made GPLv2 or better .. 
But sincerely, I do not have too much knowledge into this, 
So I'll let maintainers decide if they see benefit in moving to GPLv2 ?


>>
>> Request you please _not_ to tag generic driver frameworks with any
>> specific company names, and let open-source be independent of any
>> commercial company tags.
>
>Are you sure about that?  Run git grep "redhat" on folder kernel\ and
>see what you get.
>
Something which may have been done repeatedly in past, may not mean
it is correct OR the only way to do it. :-)


>> Otherwise eventually everything generic driver
>> will have some or other company name associated with it.
>
>What's the problem of that?  People are paid to do generic work, and why
>shouldn't their employer's name be mentioned to give the credit.  As
>long as the copyright is GPL, the code can be used, modified and
>distributed freely, and I do not see any problem with having company
>name in there.
>
It's not about who is taking credit. It's about how will you track the developer
if after few years you want some significant changes in the code he wrote.
You would agree, it's difficult to track developers just by their company names
or company IDs. 
It's perfectly okay, if you want to give credits of your work to anyone
(whether any company or individual). But that you can mention in commit logs.

All I said was using company names in Headers or MODULE_AUTHOR of
*generic frameworks*. A generic framework is maintained and updated
by community at large. And over course of time other people contribute
more than the author. So tagging a company name there would sound like
_repeatedly_ giving credit to company or yourself, even if most of the
original  code is changed now. Does that make sense ?

So, I just suggested to keep generic framework code free from all these.
However, You are free to do anything in your controller specific code.


with regards, pekon
