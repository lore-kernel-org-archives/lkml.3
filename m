Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3GWJPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:15:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:45232 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3GWJPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:15:34 -0400
Message-ID: <51EE49B4.2050508@linutronix.de>
Date: Tue, 23 Jul 2013 11:15:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 05/16] usb: musb: dsps: use proper child nodes
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-6-git-send-email-bigeasy@linutronix.de> <51EE26C4.30508@ti.com>
In-Reply-To: <51EE26C4.30508@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:46 AM, George Cherian wrote:
>> diff --git a/arch/arm/boot/dts/am335x-evm.dts
>> b/arch/arm/boot/dts/am335x-evm.dts
>> index 3aee1a4..a3a642a 100644
>> --- a/arch/arm/boot/dts/am335x-evm.dts
>> +++ b/arch/arm/boot/dts/am335x-evm.dts
>> @@ -171,6 +171,26 @@
>>               };
>>           };
>>   +        musb: usb@47400000 {
>> +            status = "okay";
>> +
>> +            phy@47401300 {
>> +                status = "okay";
>> +            };
>> +
>> +            phy@47401b00 {
>> +                status = "okay";
>> +            };
>> +
>> +            usb@47401000 {
>> +                status = "no";
>> +            };
> Any reason usb0 is disabled for am33xx evm? Just for testing?

No, that is an error and will be corrected.

Please try to reduce the email in reply to sane size / context. Here
the reader notices the file you refer to and your comment. Quoting the
whole patch eats up more resources for processing plus the reader might
overlook additional comments (he most likely will search for at least
one line).

Sebastian
