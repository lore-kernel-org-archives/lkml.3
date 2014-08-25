Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaHYQ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:58:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbaHYQ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:58:19 -0400
Message-ID: <53FB6B26.3030906@infradead.org>
Date: Mon, 25 Aug 2014 09:58:14 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Proofread documentation
References: <1408956471-16579-1-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1408956471-16579-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/14 01:47, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/power/regulator/consumer.txt  | 7 ++++---
>  Documentation/power/regulator/design.txt    | 8 ++++----
>  Documentation/power/regulator/machine.txt   | 4 ++--
>  Documentation/power/regulator/overview.txt  | 6 +++---
>  Documentation/power/regulator/regulator.txt | 6 +++---
>  5 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
> index 81c0e2b49cd8..8afb236ca765 100644
> --- a/Documentation/power/regulator/consumer.txt
> +++ b/Documentation/power/regulator/consumer.txt
> @@ -143,8 +143,9 @@ This will cause the core to recalculate the total load on the regulator (based
>  on all its consumers) and change operating mode (if necessary and permitted)
>  to best match the current operating load.
>  
> -The load_uA value can be determined from the consumers datasheet. e.g.most
> -datasheets have tables showing the max current consumed in certain situations.
> +The load_uA value can be determined from the consumer's datasheet. e.g. most

Prefer:                                                               E.g.

otherwise,
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> +datasheets have tables showing the maximum current consumed in certain
> +situations.
>  
>  Most consumers will use indirect operating mode control since they have no
>  knowledge of the regulator or whether the regulator is shared with other


-- 
~Randy
