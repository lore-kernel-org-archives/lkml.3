Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbbAZKft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:35:49 -0500
Received: from smtp-out-156.synserver.de ([212.40.185.156]:1064 "EHLO
	smtp-out-156.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbAZKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:35:46 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11168
Message-ID: <54C6187F.4050802@metafoo.de>
Date: Mon, 26 Jan 2015 11:35:43 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, tiwai@suse.de,
        perex@perex.cz
CC: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/4] sound: soc: jz4740: Add dynamic sampling rate support
 to jz4740-i2s
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-2-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1422267511-6649-2-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 11:18 AM, Zubair Lutfullah Kakakhel wrote:
[...]
>   #define JZ_AIC_I2S_FMT_DISABLE_BIT_CLK BIT(12)
> +#define JZ_AIC_I2S_FMT_DISABLE_BIT_ICLK BIT(13)

This looks like it slipped in by accident. Otherwise the patch looks good.
