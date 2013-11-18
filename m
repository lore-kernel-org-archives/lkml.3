Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3KROYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:24:34 -0500
Received: from smtp-out-249.synserver.de ([212.40.185.249]:1088 "EHLO
	smtp-out-164.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751301Ab3KROYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:24:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1147
Message-ID: <528A232B.9070402@metafoo.de>
Date: Mon, 18 Nov 2013 15:24:43 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Florian Meier <florian.meier@koalo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ASoC: Add support for BCM2835
References: <5289F9DF.8060406@koalo.de> <20131118141637.GI30853@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131118141637.GI30853@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 03:16 PM, Mark Rutland wrote:
> 
>> +static void bcm2835_i2s_stop_clock(struct bcm2835_i2s_dev *dev)
>> +{
>> +       uint32_t clkreg;
> 
> s/uint32_t/u32/ (and elsewhere...)

Please don't do that.

