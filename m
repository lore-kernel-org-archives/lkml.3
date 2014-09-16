Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaIPXFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:05:10 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54598 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaIPXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:05:08 -0400
Message-ID: <5418C224.8050504@linaro.org>
Date: Tue, 16 Sep 2014 16:05:08 -0700
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v10 5/9] arm: omap1: Migrate debug_ll macros to use 8250.S
References: <1410907588-19957-1-git-send-email-daniel.thompson@linaro.org> <1410907588-19957-6-git-send-email-daniel.thompson@linaro.org> <20140916225810.GA1273@drone.musicnaut.iki.fi>
In-Reply-To: <20140916225810.GA1273@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/14 15:58, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, Sep 16, 2014 at 11:46:24PM +0100, Daniel Thompson wrote:
>> +	config DEBUG_OMAP1UART1
>> +		bool "Kernel low-level debugging via OMAP1 UART1"
>> +		depends on ARCH_OMAP1
>> +		select DEBUG_UART_8250
>> +		help
>> +		  Say Y here if you want kernel low-level debugging support
>> +		  on OMAP1 based platforms (expect OMAP730) on the UART1.
>                                             ^^^^^^
> 
>> +		select DEBUG_UART_8250
>> +		help
>> +		  Say Y here if you want kernel low-level debugging support
>> +		  on OMAP1 based platforms (expect OMAP730) on the UART2.
>                                             ^^^^^^
> 
>> +		select DEBUG_UART_8250
>> +		help
>> +		  Say Y here if you want kernel low-level debugging support
>> +		  on OMAP1 based platforms (expect OMAP730) on the UART3.
>                                             ^^^^^^
> 
> I already commented earlier, that "expect" here is probably a typo?

I'm extremely sorry to have overlooked your previous comment. There's
certainly no question I read your previous e-mail because because I
copied your Tested-by: from it.

I will fix this (and also grep all other patches in the set to make sure
I haven't copied the typo anywhere else).


Daniel.
