Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab3LBFA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:00:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3LBFA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:00:57 -0500
Message-ID: <529C1403.4040100@infradead.org>
Date: Sun, 01 Dec 2013 21:00:51 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, levex@linux.com, rob@landley.net
Subject: Re: [PATCH/v3] [trivial] doc: Fix typo in Documentation/devicetree
References: <1385817454-19505-1-git-send-email-standby24x7@gmail.com> <1385823579-31255-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1385823579-31255-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/13 06:59, Masanari Iida wrote:
> Correct spelling typo in Documentation/devicetree
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Reviewed-By: Levente Kurusa <levex@linux.com>

Has Levente replied to this patch with his Reviewed-by: tag?
You should not add it just because he has reviewed the patch.
It is up to him to send his Reviewed-by: comment explicitly.


> 
> ---
>  Documentation/devicetree/bindings/arm/omap/timer.txt        | 2 +-
>  Documentation/devicetree/bindings/bus/mvebu-mbus.txt        | 2 +-
>  Documentation/devicetree/bindings/crypto/fsl-sec6.txt       | 2 +-
>  Documentation/devicetree/bindings/gpio/mrvl-gpio.txt        | 2 +-
>  Documentation/devicetree/bindings/mfd/s2mps11.txt           | 2 +-
>  Documentation/devicetree/bindings/mmc/samsung-sdhci.txt     | 2 +-
>  Documentation/devicetree/bindings/mmc/synopsys-dw-mshc.txt  | 4 ++--
>  Documentation/devicetree/bindings/phy/phy-bindings.txt      | 2 +-
>  Documentation/devicetree/bindings/spi/spi-bus.txt           | 2 +-
>  Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt | 2 +-
>  Documentation/devicetree/bindings/video/atmel,lcdc.txt      | 4 ++--
>  11 files changed, 13 insertions(+), 13 deletions(-)

-- 
~Randy
