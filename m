Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3BFTU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:20:29 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39773 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3BFTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:20:26 -0500
Message-ID: <5112ACF5.3020906@kernel.org>
Date: Wed, 06 Feb 2013 19:20:21 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
References: <1357752671-30222-1-git-send-email-lars@metafoo.de> <20130127033358.GA20672@sirena.org.uk> <20130205140755.33FCD3E1265@localhost>
In-Reply-To: <20130205140755.33FCD3E1265@localhost>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 02:07 PM, Grant Likely wrote:
> On Sun, 27 Jan 2013 03:33:59 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>> On Wed, Jan 09, 2013 at 06:31:09PM +0100, Lars-Peter Clausen wrote:
>>
>>> The second function spi_sync_transfer() takes a SPI device and an array of
>>> spi_transfers. It will allocate a new spi_message (on the stack) and add all
>>> transfers in the array to the message. Finally it will call spi_sync() on the
>>> message.
>>
>> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Looks good to me also. Go ahead and merge this series through the iio
> tree since it is the first user.

Lars, when you are back on your feet, could you respin this series against
the latest iio tree please.  2 drivers have moved which messes up patches
2 and 3. Now I could fix it up, but it's your patch series and I'm lazy ;)


> 
> g.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
