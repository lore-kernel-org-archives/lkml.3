Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab3D3Mk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:40:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:40238 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab3D3MkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:40:25 -0400
Message-ID: <517FBBBB.6060003@atmel.com>
Date: Tue, 30 Apr 2013 14:40:27 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jon Medhurst <tixy@linaro.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next build error (at91) - use of bool in mach/arch.h
References: <517F8FF4.3050901@atmel.com> <CAMuHMdXYaDHYq7CG8ftP+yyF18pMx8qZrvM3AUTAXk+tUruNcA@mail.gmail.com> <alpine.DEB.2.02.1304301257200.5398@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1304301257200.5398@kaball.uk.xensource.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 01:58 PM, Stefano Stabellini :
> On Tue, 30 Apr 2013, Geert Uytterhoeven wrote:
>> On Tue, Apr 30, 2013 at 11:33 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>>> So, I am wondering if the best correction is to add the types.h header file
>>> in the asm/mach/arch.h file, like this:
>>>
>>> --- a/arch/arm/include/asm/mach/arch.h
>>> +++ b/arch/arm/include/asm/mach/arch.h
>>> @@ -8,6 +8,8 @@
>>>   * published by the Free Software Foundation.
>>>   */
>>>
>>> +#include <linux/types.h>
>>> +
>>>  #ifndef __ASSEMBLY__
>>>
>>>  struct tag;
>>>
>>> or if a better option would be to re-arrange the include directives in
>>> various at91xxx_devices.c files?
>>
>> Include files should be self-contained, so asm/mach/arch.h is the right place.
> 
> Nicolas,
> are you happy to come up with a proper patch to fix the issue?

Yep, sent now.

Bye,
-- 
Nicolas Ferre
