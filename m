Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaFPOKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:10:15 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:40296 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPOKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:10:13 -0400
X-LoopCount0: from 10.175.216.249
X-IronPort-AV: E=Sophos;i="5.01,486,1400043600"; 
   d="scan'208";a="650403639"
From: <B_B_Singh@DELL.com>
To: <teg@jklm.no>
CC: <linux-kernel@vger.kernel.org>, <ming.lei@canonical.com>,
        <gregkh@linuxfoundation.org>, <Abhay_Salunke@DELL.com>, <sr@denx.de>,
        <arnd@arndb.de>, <kay@vrfy.org>, <Matt_Domsch@DELL.com>,
        <Srinivas_G_Gowda@DELL.com>, <Stuart_Hayes@DELL.com>
Date: Mon, 16 Jun 2014 19:38:57 +0530
Subject: RE: [PATCH] firmware loader: allow disabling of udev as firmware
 loader
Thread-Topic: [PATCH] firmware loader: allow disabling of udev as firmware
 loader
Thread-Index: Ac+D+qAxcokn2SjjSfCY2krbpdUX/gAwfJSgASvhSWA=
Message-ID: <8B2F6FFD0BD1E448853114367400A37306FCDFE8A7@BLRX7MCDC203.AMER.DELL.COM>
References: <8B2F6FFD0BD1E448853114367400A37306FCD2E023@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqUDQ3e-cq4y3zgehz6J8E6LsTCUfqvMEqPEqG7aBmEeRg@mail.gmail.com>
 <8B2F6FFD0BD1E448853114367400A37306FCD2E02A@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqXBOfZTGi-S=AzjGYDyGWkh0ijz73_pUUtmFdmQkgxWVQ@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.5.29.3
x-tituslabs-classifications-30: TLPropertyRoot=Dell;Classification=No
 Restrictions;Sublabels=;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7IkiU+F178WdT0jfKBxULWaA/cMBTWLEh0ZXdCvZnZCD1UgSA1vsFP1X01xwEut6SdChzE2nj+IFVL5wFINa/zYUTggtPu2KfanVOQXJsajfBunZrJGE/XVNUDX98x9kd/LzgmUoV8pWgoLmJDZKE7Qt5aEJOPxvNMQF5PHdaiZYnjHXLzKoOEMc6HgnCcTPVlt9UipDnjg2ek+tcSnih8eG6I5M5mjAXwHaduRMRe7DxtuJKQAhnZn7WdpIBTz6K8A==
x-titusconfig: 1.4AMER
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Today I have tried with 3.15 the behavior is same as before.

Do you have any update on this?

Regards
Balaji Singh

-----Original Message-----
From: Singh, B B
Sent: Tuesday, June 10, 2014 8:44 PM
To: 'Tom Gundersen'
Cc: LKML; Ming Lei; Greg KH; Abhay Salunke; Stefan Roese; Arnd Bergmann; Kay Sievers; Domsch, Matt; Gowda, Srinivas G; Hayes, Stuart
Subject: RE: [PATCH] firmware loader: allow disabling of udev as firmware loader


Hi Tom,

I see contradiction of drivers/base/Kconfig here i.e, If I configure DELL_RBU=y I cannot configure FW_LOADER_USER_HELPER=n. 
with this patch https://lkml.org/lkml/2014/6/4/327 i cannot have FW_LOADER_USER_HELPER=n & DELL_RBU=y at the same time. 
I'm using the latest stable upstream kernel-3.14.5.

Symbol: FW_LOADER_USER_HELPER [=y]
Type : boolean
Defined at drivers/base/Kconfig:146
Selected by: FW_LOADER_USER_HELPER_FALLBACK [=n] && FW_LOADER [=y] || DELL_RBU [=y] && X86 [=y]

Regards
Balaji Singh


-----Original Message-----
From: Tom Gundersen [mailto:teg@jklm.no]
Sent: Monday, June 09, 2014 9:21 PM
To: Singh, B B
Cc: LKML; Ming Lei; Greg KH; Abhay Salunke; Stefan Roese; Arnd Bergmann; Kay Sievers; Domsch, Matt; Gowda, Srinivas G; Hayes, Stuart
Subject: Re: [PATCH] firmware loader: allow disabling of udev as firmware loader

On Mon, Jun 9, 2014 at 4:01 PM, wrote:
> Older userspace or existing DUP's doesn't work with your patch & CONFIG_FW_LOADER_USER_HELPER=n.
>
> I will give a try with https://lkml.org/lkml/2014/6/4/327 new patch & let you know ASAP.

Thanks!

Cheers,

Tom
