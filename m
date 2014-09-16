Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaIPW60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:58:26 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:38331 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaIPW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:58:24 -0400
Date: Wed, 17 Sep 2014 01:58:10 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v10 5/9] arm: omap1: Migrate debug_ll macros to use 8250.S
Message-ID: <20140916225810.GA1273@drone.musicnaut.iki.fi>
References: <1410907588-19957-1-git-send-email-daniel.thompson@linaro.org>
 <1410907588-19957-6-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410907588-19957-6-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 16, 2014 at 11:46:24PM +0100, Daniel Thompson wrote:
> +	config DEBUG_OMAP1UART1
> +		bool "Kernel low-level debugging via OMAP1 UART1"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART1.
                                            ^^^^^^

> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART2.
                                            ^^^^^^

> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART3.
                                            ^^^^^^

I already commented earlier, that "expect" here is probably a typo?

A.
