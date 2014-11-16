Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaKPAaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:30:08 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:41020 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaKPAaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:30:06 -0500
Date: Sun, 16 Nov 2014 02:29:56 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v12 11/15] arm: omap1: Migrate debug_ll macros to use
 8250.S
Message-ID: <20141116002956.GA13220@fuloong-minipc.musicnaut.iki.fi>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
 <1414148076-12685-12-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414148076-12685-12-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 24, 2014 at 11:54:32AM +0100, Daniel Thompson wrote:
> +	config DEBUG_OMAP1UART1
> +		bool "Kernel low-level debugging via OMAP1 UART1"
> +		depends on ARCH_OMAP1
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on OMAP1 based platforms (expect OMAP730) on the UART1.
[...]
> +		  on OMAP1 based platforms (expect OMAP730) on the UART2.
[...]
> +		  on OMAP1 based platforms (expect OMAP730) on the UART3.
                                            ^^^^^^

Spelling again wrong. I think it was already corrected in v11?

A.
