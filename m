Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3E3Nfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:35:53 -0400
Received: from mta.cujae.edu.cu ([200.55.139.24]:51877 "EHLO
	mtaext1.cujae.edu.cu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755983Ab3E3Nff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:35:35 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 09:35:34 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.9
X-Spam-Processed: udio.cujae.edu.cu, Thu, 30 May 2013 09:24:13 -0400
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: acabrera@udio.cujae.edu.cu
X-MDRemoteIP: 10.9.3.110
X-Return-Path: acabrera@udio.cujae.edu.cu
X-Envelope-From: acabrera@udio.cujae.edu.cu
Message-ID: <51A76199.5010004@udio.cujae.edu.cu>
Date: Thu, 30 May 2013 09:26:33 -0500
From: Alejandro Cabrera <acabrera@udio.cujae.edu.cu>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64;
	rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Venu Byravarasu <vbyravarasu@nvidia.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 1/3] watchdog: xilinx: Fix driver header
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
	<D958900912E20642BCBC71664EFECE3E6E51FD29A4@BGMAIL02.nvidia.com>
	<51A746F3.5030503@monstr.eu>
In-Reply-To: <51A746F3.5030503@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30/5/2013 7:32 AM, Michal Simek wrote:
> On 05/30/2013 02:30 PM, Venu Byravarasu wrote:
>>> -----Original Message-----
>>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>>> owner@vger.kernel.org] On Behalf Of Michal Simek
>>> Sent: Thursday, May 30, 2013 5:56 PM
>>> To: linux-kernel@vger.kernel.org
>>> Cc: Michal Simek; Michal Simek; Wim Van Sebroeck; linux-
>>> watchdog@vger.kernel.org
>>> Subject: [PATCH 1/3] watchdog: xilinx: Fix driver header
>>>
>>> * PGP Signed by an unknown key
>>>
>>> - Remove reference for IP version
>>> - Fix header coding style
>>> - Remove notes which are visible from the code
>>> - Fix driver license according to header
>>>
>>> Signed-off-by: Michal Simek<michal.simek@xilinx.com>
>>> ---
>>>   drivers/watchdog/of_xilinx_wdt.c | 30 ++++++++++--------------------
>>>   1 file changed, 10 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/watchdog/of_xilinx_wdt.c
>>> b/drivers/watchdog/of_xilinx_wdt.c
>>> index 2761ddb..d4a35ab 100644
>>> --- a/drivers/watchdog/of_xilinx_wdt.c
>>> +++ b/drivers/watchdog/of_xilinx_wdt.c
>>> @@ -1,23 +1,13 @@
>>>   /*
>>> -*   of_xilinx_wdt.c  1.01  A Watchdog Device Driver for Xilinx
>>> xps_timebase_wdt
>>> -*
>>> -*   (C) Copyright 2011 (Alejandro Cabrera<aldaya@gmail.com>)
>>> -*
>>> -*       -----------------------
>>> -*/
>>> + * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
>>> + *
>>> + * (C) Copyright 2011 (Alejandro Cabrera<aldaya@gmail.com>)
>> Should year not be updated?
> This is just header fixup.
> I think he is not working/maintaining this driver for a long time.
Indeed :(.
Since this driver was upstream the new watchdog subsystem was under 
development and I want to port it to the new core, but unfortunately I 
haven't enough time :(.
> I would write there Xilinx copyright but I really don't care.
>
> Thanks,
> Michal
Thanks, you,
Alejandro




48 Aniversario de la Cujae, Una obra de la Revolucion Cubana | 2 de diciembre de 1964 | http://cujae.edu.cu

Consulte la enciclopedia colaborativa cubana. http://www.ecured.cu
