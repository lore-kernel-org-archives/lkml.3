Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3JDIJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:09:11 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:35843
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751346Ab3JDIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:09:05 -0400
Message-ID: <524E779E.5040804@newflow.co.uk>
Date: Fri, 04 Oct 2013 09:09:02 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        device-tree <devicetree-discuss@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3] Add support for Newflow NanoBone board
References: <524298FE.4090200@newflow.co.uk>
In-Reply-To: <524298FE.4090200@newflow.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/13 09:04, Mark Jackson wrote:
> NanoBone Specification:
> -----------------------
> CPU:
>   TI AM335x
> 
> Memory:
>   256MB DDR3
>   128MB NOR flash
>   128KB FRAM
> 
> Ethernet:
>   2 x 10/100 connected to SMSC LAN8710 PHY
> 
> USB:
>   1 x USB2.0 Type A
> 
> I2C:
>   2Kbit EEPROM (Microchip 24AA02)
>   RTC (Maxim DS1338)
>   GPIO Expander (Microchip MCP23017)
> 
> Expansion connector:
>   6 x UART
>   1 x MMC/SD
>   1 x USB2.0
> 
> Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

<snip>

Any chance someone could accept / comment on this patch ?

Cheers
Mark J.
