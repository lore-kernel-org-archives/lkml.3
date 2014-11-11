Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaKKJM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:12:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaKKJMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:12:25 -0500
Message-ID: <5461D2C1.6020505@redhat.com>
Date: Tue, 11 Nov 2014 10:11:29 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [linux-sunxi] [PATCH v2 0/5] ARM: sunxi: Add support for USB
 OTG PHY
References: <cover.1415645258.git.rbyshko@gmail.com>
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/10/2014 07:55 PM, Roman Byshko wrote:
> Hi,
> 
> There is already support for two USB phys, which are used for
> USB host controllers on Allwinner SoC aka sunxi.
> 
> This patch series add support for the USB OTG phy (aka phy0).
> 
> The code has been tested on Allwinner A20 aka sun7i (Cubietruck).
> 
> Best regards,
> Roman Byshko

First of all very cool that you're working on this, I somehow missed
v1, but I'm very happy to see this.

Second some questions, this series seems to only add support for
initializing the phy, without adding the necessary magic for
switching from app to host mode, and without actually hooking up musb,
I assume you've a follow up series adding musb support, which actually
uses the phy ?

Also have you coordinated your work with ChenYu? ATM ChenYu is mostly
working on other stuff, but AFAIk he has been working on musb support
in the past.

Regards,

Hans
