Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaHBNAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:00:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaHBNAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:00:42 -0400
Message-ID: <53DCE0F4.4060101@suse.de>
Date: Sat, 02 Aug 2014 15:00:36 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 03/10] ARM: dts: Prepare node labels for exynos5250
References: <1406940750-15880-1-git-send-email-afaerber@suse.de> <1406940750-15880-4-git-send-email-afaerber@suse.de> <53DCD74B.8090400@gmail.com>
In-Reply-To: <53DCD74B.8090400@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.08.2014 14:19, schrieb Tomasz Figa:
> Andreas,
> 
> Ehh, one more thing. It looks like my memory is playing tricks on me.
> Please see inline.
> 
> On 02.08.2014 02:52, Andreas Färber wrote:
>> Allows them to be extended by reference.
>>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>  v6: Split off from Snow/SMDK cleanups (Doug Anderson)
> 
> [snip]
> 
>> -	serial@12C00000 {
>> +	uart0: serial@12C00000 {
>>  		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
>>  		clock-names = "uart", "clk_uart_baud0";
>>  	};
>>  
>> -	serial@12C10000 {
>> +	uart1: serial@12C10000 {
>>  		clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
>>  		clock-names = "uart", "clk_uart_baud0";
>>  	};
>>  
>> -	serial@12C20000 {
>> +	uart2: serial@12C20000 {
>>  		clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
>>  		clock-names = "uart", "clk_uart_baud0";
>>  	};
>>  
>> -	serial@12C30000 {
>> +	uart3: serial@12C30000 {
>>  		clocks = <&clock CLK_UART3>, <&clock CLK_SCLK_UART3>;
>>  		clock-names = "uart", "clk_uart_baud0";
>>  	};
> 
> I forgot about a series [1] that went through tty tree, which is going
> to conflict with this patch. It already adds labels to uart nodes in
> serial_X format. I don't really remember why I went with this format for
> Exynos SoCs and with uartX for older ones...
> 
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/arch/arm/boot/dts?id=1e64f48ea7c59fb94acd7551dd9fa68b8a752efc

I doubt that I'll manage to resend another time today, so please just
drop those hunks from my patch before applying - I ended up not using
them here.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
