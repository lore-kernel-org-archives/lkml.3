Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaAHKml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:42:41 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:35181 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbaAHKmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:42:38 -0500
Message-ID: <52CD2B98.5040209@mev.co.uk>
Date: Wed, 8 Jan 2014 10:42:32 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "pisa@cmp.felk.cvut.cz" <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
References: <1389133497-10149-1-git-send-email-lisovy@gmail.com>	 <1389133497-10149-2-git-send-email-lisovy@gmail.com>	 <20140108074701.GP5443@mwanda> <1389170133.10763.6.camel@umadbro>
In-Reply-To: <1389170133.10763.6.camel@umadbro>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-08 08:35, Rostislav Lisovy wrote:
> Hello Dan;
>
> On Wed, 2014-01-08 at 10:47 +0300, Dan Carpenter wrote:
>> On Tue, Jan 07, 2014 at 11:24:57PM +0100, Rostislav Lisovy wrote:
>>> This patch adds Comedi driver for Humusoft MF634 (PCIe) and
>>> MF624 (PCI) data acquisition cards. The legacy card Humusoft
>>> MF614 is not supported. More info about the cards may be found
>>> at http://humusoft.cz/produkty/datacq/
>>> The driver was tested with both cards. Everything seems to work
>>> properly. Just the basic functionality of the card (DIO, ADC, DAC)
>>> is supported by this driver.
>>>
>>> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
>>>
>>>   create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
>>>
>>
>> There should be a "---" after the Signed-off-by line and before the
>> diffstat "create mode 100644 drivers/staging/comedi/drivers/mf6x4.c"
>> line.  Otherwise, the diffstat gets included in the changelog.
>>
>> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
>> ---
>> create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
>>
>
> You are right, my mistake. But even though there should be v3 patch
> because I just realized there is an unnecessary comment in
> mf6x4_detach() and MF6X4_DAC_CHANN_CNT constant is no more used.
>
> Regards;
> Rostislav Lisovy

I'll wait for the v3 patch, but apart from that it looks fine to me.  I 
suppose it could be argued that the driver only uses 2 of the 3 BARs it 
ioremaps (a different 2 for each card), but they're only single page 
mappings.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
