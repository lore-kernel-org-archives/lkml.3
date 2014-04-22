Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbaDVVlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:41:55 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44427 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756791AbaDVVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:40:06 -0400
Date: Tue, 22 Apr 2014 22:39:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Anders Berg <anders.berg@lsi.com>,
        olof@lixom.net, mturquette@linaro.org, mark.rutland@arm.com,
        dbaryshkov@gmail.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
Message-ID: <20140422213913.GB24070@n2100.arm.linux.org.uk>
References: <cover.1397552154.git.anders.berg@lsi.com> <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com> <8344066.GP0Bf5lvlE@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8344066.GP0Bf5lvlE@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:45:48PM +0200, Arnd Bergmann wrote:
> "uartclk" is not a valid string for pl011, as per binding:
> 
> | - clocks:  When present, must refer to exactly one clock named
> |           "apb_pclk"

The binding document is basically *wrong*.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
