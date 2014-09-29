Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaI2IgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:36:07 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:40048 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaI2IgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:36:05 -0400
Message-ID: <542919F0.9050509@atmel.com>
Date: Mon, 29 Sep 2014 10:36:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: add atmel audio alsa driver maintainer
 entry
References: <1411869439-2719-1-git-send-email-voice.shen@atmel.com> <1411869439-2719-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1411869439-2719-2-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/09/2014 03:57, Bo Shen :
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

For the record:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> ---
> 
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c004e6f..30f92cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1665,6 +1665,12 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
>  F:	drivers/tty/serial/atmel_serial.c
>  
> +ATMEL Audio ALSA driver
> +M:	Bo Shen <voice.shen@atmel.com>
> +L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
> +S:	Supported
> +F:	sound/soc/atmel
> +
>  ATMEL DMA DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> 


-- 
Nicolas Ferre
