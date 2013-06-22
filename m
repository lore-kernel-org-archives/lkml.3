Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3FVMBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 08:01:50 -0400
Received: from smtp-out-194.synserver.de ([212.40.185.194]:1079 "EHLO
	smtp-out-194.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3FVMBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 08:01:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29423
Message-ID: <51C5923D.6030609@metafoo.de>
Date: Sat, 22 Jun 2013 14:02:05 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCHv2 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com> <1371754675-12242-2-git-send-email-alexandre.belloni@free-electrons.com> <51C590B5.2060308@kernel.org>
In-Reply-To: <51C590B5.2060308@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2013 01:55 PM, Jonathan Cameron wrote:
> On 06/20/2013 07:57 PM, Alexandre Belloni wrote:
>> The Nuvoton NAU7802 ADC is a 24-bit 2-channels I2C ADC, with adjustable
>> gain and sampling rates.
>>
> Sorry, somewhat low on time today so only a quick review.
> 
> 1) Missing userspace ABI documentation.  Also, perhaps min_conversions is
>    a little vague?  Not that I have a better idea!

I really don't like the name min_conversions either. Isn't this effectively
a decimation filter?

- Lars
