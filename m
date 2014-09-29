Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaI2Tu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:50:57 -0400
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1079 "EHLO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaI2Tuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:50:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32080
Message-ID: <5429B829.3020900@metafoo.de>
Date: Mon, 29 Sep 2014 21:51:05 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        linux-kernel@vger.kernel.org
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, broonie@kernel.org
Subject: Re: [PATCH v2 1/3] ASoC: ssm2602: do not hardcode type to SSM2602
References: <1412019553-19342-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1412019553-19342-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 09:39 PM, Stefan Kristiansson wrote:
> The correct type (SSM2602/SSM2603/SSM2604) is passed down
> from the ssm2602_spi_probe()/ssm2602_spi_probe() functions,
> so use that instead of hardcoding it to SSM2602 in
> ssm2602_probe().
>
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

Fixes: c924dc68f737 ("ASoC: ssm2602: Split SPI and I2C code into different \
	modules")
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
