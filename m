Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3BLJjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:39:12 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:42330 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933Ab3BLJjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:39:09 -0500
Message-ID: <511A0DB6.1080702@gaisler.com>
Date: Tue, 12 Feb 2013 10:39:02 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 5/6] of_spi: Add fetching of of_gpio flags to of_spi_register_master
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-6-git-send-email-andreas@gaisler.com> <20130211002220.AFCA83E0C13@localhost>
In-Reply-To: <20130211002220.AFCA83E0C13@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-11 01:22, Grant Likely wrote:
> On Tue, 29 Jan 2013 15:53:42 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
>> When using a gpio chip select with a OF_GPIO_ACTIVE_LOW flag, this needs to be
>> known to the controller driver.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>
> Out of curiosity, what do you need the flags for? Polarity of the CS
> signal? I think it is long past time to revisit baking polarity control
> into core of gpiolib. Would you mind investigating doing that instead of
> having to manage it manually in each and every driver?

I don't even need it on my hardware. It seemed like a good thing to have 
via of_spi_register_master. I am OK with just dropping this.

Cheers,
Andreas

