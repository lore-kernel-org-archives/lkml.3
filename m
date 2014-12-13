Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbaLMLaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 06:30:04 -0500
Received: from smtp-out-084.synserver.de ([212.40.185.84]:1059 "EHLO
	smtp-out-084.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030287AbaLMLaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 06:30:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9039
Message-ID: <548C2335.7080301@metafoo.de>
Date: Sat, 13 Dec 2014 12:29:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org
CC: Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v2 2/2] iio: add driver for the TI DAC8554
References: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de> <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de>
In-Reply-To: <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:50 PM, Nikolaus Schulz wrote:
[...]
> +const struct iio_chan_spec dac8554_channels[] = {

static

[...]
> +	ret = of_property_read_u32(spi->dev.of_node, "address", &addr);

This should probably have vendor prefix.

> +	if (ret || addr < 0 || addr > 2) {
> +		dev_err(&spi->dev, "no or invalid chip address");
> +		return -ENODEV;
> +	}


