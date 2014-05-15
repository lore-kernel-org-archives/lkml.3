Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaEOK01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:26:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46342 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaEOK00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:26:26 -0400
Message-ID: <5374962F.2050004@ti.com>
Date: Thu, 15 May 2014 15:55:51 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: remove checks for CONFIG_USB_MUSB_PERIPHERAL
References: <1400149025.20469.22.camel@x220>
In-Reply-To: <1400149025.20469.22.camel@x220>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 03:47 PM, Paul Bolle wrote:
> The Kconfig symbol USB_MUSB_PERIPHERAL was removed in v3.1. The last two
> checks for its macro now always evaluate to false. So remove these
> checks.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Eyeball tested only.
> 
> This is just a straightforward cleanup. It does remove a comment. Is
> that comment still useful? Anyhow, I do wonder whether a proper fix is
> possible here. Perhaps Greg or Felipe knows: it is their commit
> 622859634a66 ("usb: musb: drop a gigantic amount of ifdeferry") that
> removed USB_MUSB_PERIPHERAL. On the other hand I noticed that config
> USB_MUSB_DAVINCI depends on BROKEN. So maybe properly fixing just this
> small problem doesn't buy us much.

Yes, it doesn't buy us much. I will still apply this anyway. The next
person can save time spent searching for non-existing symbols.

Thanks,
Sekhar

