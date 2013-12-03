Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3LCLzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:55:06 -0500
Received: from smtp-out-012.synserver.de ([212.40.185.12]:1090 "EHLO
	smtp-out-110.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752866Ab3LCLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:55:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13280
Message-ID: <529DC6BE.3080607@metafoo.de>
Date: Tue, 03 Dec 2013 12:55:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, linus.walleij@linaro.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: ux500_pcm: Differentiate between
 pdata and DT initialisation
References: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 11:27 AM, Lee Jones wrote:
> If booting with full DT support (i.e. DMA too, the last piece of the
> puzzle), then we don't need to use the compatible_request_channel call
> back or require some of the historical bumph which probably isn't
> required by a platform data start-up now either. This will also be
> ripped out in upcoming commits.
> 
> Cc: alsa-devel@alsa-project.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Strictly speaking you do not need the second config, but well considering
that this will all hopefully be removed soon anyway it should be fine.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
