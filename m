Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3KVNcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:32:25 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:60390 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3KVNcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:32:23 -0500
Message-ID: <528F5CE3.30105@koalo.de>
Date: Fri, 22 Nov 2013 14:32:19 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4] ASoC: Add support for BCM2835
References: <528E4E4A.20403@koalo.de>
In-Reply-To: <528E4E4A.20403@koalo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev),
> +			   GFP_KERNEL);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);

Found a typo here, should be IS_ERR(dev) and PTR_ERR(dev).

Is the patch acceptable apart from that now?

Greetings,
Florian
