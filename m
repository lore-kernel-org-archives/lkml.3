Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LMJ4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:56:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56545 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab3LMJ4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:56:49 -0500
Message-ID: <52AAD9A6.40907@ti.com>
Date: Fri, 13 Dec 2013 15:25:50 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <balbi@ti.com>, Matt Porter <mporter@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v5 1/9] phy: add phy_get_bus_width()/phy_set_bus_width()
 calls
References: <1386854770-2173-1-git-send-email-mporter@linaro.org> <1386854770-2173-2-git-send-email-mporter@linaro.org> <20131212181818.GI1939@saruman.home>
In-Reply-To: <20131212181818.GI1939@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 11:48 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Dec 12, 2013 at 08:26:02AM -0500, Matt Porter wrote:
>> This adds a pair of APIs that allows the generic PHY subsystem to
>> provide information on the PHY bus width. The PHY provider driver may
>> use phy_set_bus_width() to set the bus width that the PHY supports.
>> The controller driver may then use phy_get_bus_width() to fetch the
>> PHY bus width in order to properly configure the controller.
>>
>> Signed-off-by: Matt Porter <mporter@linaro.org>
> 
> Kishon, I need your Acked-by here, if you're ok with the change.

here it goes..
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> 

