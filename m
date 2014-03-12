Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaCLBsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:48:19 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36832 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbaCLBsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140312011116.GJ28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
	<1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
	<20140311194959.GB28112@sirena.org.uk>
	<CAMo8BfLTn+pneF6_7XkP66+LzpZgcefnAo_FkwxpvtYdt9yduA@mail.gmail.com>
	<20140312003401.GE28112@sirena.org.uk>
	<CAMo8Bf+dePYf0jW6zaH-4Qiy5oF-bBzHjkfzL1u6pyTS1OE46w@mail.gmail.com>
	<20140312011116.GJ28112@sirena.org.uk>
Date: Wed, 12 Mar 2014 05:48:16 +0400
Message-ID: <CAMo8BfKFp1kz8S_4JbSh5=f+hMygJL1670fkFfzdArgDqtW72A@mail.gmail.com>
Subject: Re: [PATCH 1/3] spi: add xtfpga SPI controller driver
From: Max Filippov <jcmvbkbc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 5:11 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Mar 12, 2014 at 04:59:47AM +0400, Max Filippov wrote:
>
>> And tlv320aic23 has the following regmap:
>
>> const struct regmap_config tlv320aic23_regmap = {
>>         .reg_bits = 7,
>>         .val_bits = 9,
>
>> and its SPI interface accordingly does the following in .probe:
>
>>         spi->bits_per_word = 16
>>         spi->mode = SPI_MODE_0;
>>         ret = spi_setup(spi);
>
> So I just looked again - the SPI code isn't in mainline, there must
> be some out of tree patches here that can't have been tested since the
> driver was converted to regmap (or the byte swapping you're doing in the
> controller is buggy for 16 bits per word).

I'm successfully running this driver with the patches in your ASoC tree
branch topic/tlv320aic23.

-- 
Thanks.
-- Max
