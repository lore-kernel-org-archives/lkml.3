Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaI2TpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:45:05 -0400
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1077 "EHLO
	smtp-out-071.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751895AbaI2TpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:45:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23864
Message-ID: <5429B6C9.7080502@metafoo.de>
Date: Mon, 29 Sep 2014 21:45:13 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        linux-kernel@vger.kernel.org
CC: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, broonie@kernel.org
Subject: Re: [PATCH v2 2/3] ASoC: ssm2602: add device tree bindings
References: <1412019670-19429-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1412019670-19429-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 09:41 PM, Stefan Kristiansson wrote:
> Allow the ssm2602/ssm2603/ssm2604 codec driver to be
> instantiated from the device tree.
>
> Also, add Kconfig prompts to allow manual selection of both the
> I2C and SPI configuration versions of the driver.
>
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

