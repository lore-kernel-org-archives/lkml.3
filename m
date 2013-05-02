Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690Ab3EBTs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:48:58 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56837 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3EBTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:48:56 -0400
Message-ID: <5182C322.3030304@gmail.com>
Date: Thu, 02 May 2013 21:48:50 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130502185322.GA29333@obsidianresearch.com> <5182B902.7040908@gmail.com> <20130502193510.GA29522@obsidianresearch.com>
In-Reply-To: <20130502193510.GA29522@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 09:35 PM, Jason Gunthorpe wrote:
> I have kirkwood HW but I haven't had time to make newer kernels run on
> it, otherwise I'd test it too :(

I also have kirkwood HW but that will cut me from email as I use it as
relay server ;) Maybe I can turn it into a test bed for a while.

There is also Orion5x and Discovery Innovation (mv78xx0) to be tested.

@Jason Cooper: I will merge both irqchip and dove patches into one
patch set. I wasn't earlier because I didn't want the above SoCs to
slow down patch integration. And I will split dtsi changes into
separate patches as requested.

Sebastian

