Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaHEMFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:05:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65121 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaHEMFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:05:45 -0400
Message-ID: <53E0C839.3000808@gmail.com>
Date: Tue, 05 Aug 2014 17:34:09 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@linaro.org, heikki.krogerus@linux.intel.com,
        paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org,
        dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com,
        mingo@elte.hu, balbi@ti.com, heiko@sntech.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 2/3] tty: serial: 8250: Add Mediatek UART driver
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>	 <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>	 <53E0C633.7060600@gmail.com> <1407240147.30675.29.camel@acox1-desk.ger.corp.intel.com>
In-Reply-To: <1407240147.30675.29.camel@acox1-desk.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 05:32 PM, Alan Cox wrote:
> On Tue, 2014-08-05 at 17:25 +0530, Varka Bhadram wrote:
>> On 08/05/2014 04:24 PM, Matthias Brugger wrote:
>>
>> (...)
>>
>>> +#include <linux/io.h>
>>> +#include <linux/module.h>
>>> +#include <linux/serial_8250.h>
>>> +#include <linux/of_irq.h>
>>> +#include <linux/of_platform.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/clk.h>
>>> +#include <linux/pm_runtime.h>
>>> +#include "8250.h"
>>> +
>> Better if we have includes in alphabetical order..
>
> So 8250.h would be first and it wouldn't compile ???
>
> Can we stick to serious critiques ?

The local headers should be at the end of all includes..?


-- 
Regards,
Varka Bhadram.

