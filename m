Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbbAZLcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:32:53 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:41759 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAZLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:32:50 -0500
Message-ID: <54C625DE.7030500@imgtec.com>
Date: Mon, 26 Jan 2015 11:32:46 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 2/4] dt: sound: jz4740: Add binding documentation for
 jz4740-i2s
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-3-git-send-email-Zubair.Kakakhel@imgtec.com> <54C618ED.1090909@metafoo.de>
In-Reply-To: <54C618ED.1090909@metafoo.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26/01/15 10:37, Lars-Peter Clausen wrote:
> On 01/26/2015 11:18 AM, Zubair Lutfullah Kakakhel wrote:
> [...]
>> +Required properties:
>> +- compatible : "ingenic,jz4740-i2s"
>> +- reg : I2S registers location and length
>> +- clocks : AIC and I2S PLL clock specifiers.
>> +- clock-names: "aic" and "i2s"
> 
> We also need a handle to the DMA channels. Currently the request ids are hardcoded in the driver, but that needs to go away once the driver starts to support multiple SoCs with different request lines.

I know. I've left DMA until we push the jz4780-dma driver upstream and see how things fit..

ZubairLK
