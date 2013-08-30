Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3H3Lbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:31:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3H3Lbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:31:48 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-d5-522082a218b6
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377794350-12335-1-git-send-email-dianders@chromium.org>
 <1377794350-12335-3-git-send-email-dianders@chromium.org>
In-reply-to: <1377794350-12335-3-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v7 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
Date: Fri, 30 Aug 2013 20:31:46 +0900
Message-id: <000201cea574$8287f2a0$8797d7e0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6k1lNuN/xG/+XJQROf1VSRuFf4twAlW4EA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zQ91FTQpBBp8+61k8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4MvbtX8lc
	cEm74u+mzAbGtUpdjJwcEgImEq3tT9ggbDGJC/fWA9lcHEICyxglvm5qYYQpWndvBQtEYjqj
	xM897UwQzh9GiRNNE5lBqtgEtCT+vnkDZosIeEm82P2AGaSIWeARk8TdJbOZITr2MEocvXQY
	aBYHB6eAm8S3pYYgprBAgsT5M/ogvSwCqhITJq8Em8MrYCvRcekJlC0o8WPyPRYQm1nAQOL9
	rD5WCFteYvOat8wgYyQE1CUe/dWFOMFIomfiJGaIEhGJfS/eMYJcICEwlUNiw601zBC7BCS+
	TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6BUn
	5haX5qXrJefnbmKERP6EHYz3DlgfYkwGWj+RWUo0OR+YOPJK4g2NzYwsTE1MjY3MLc1IE1YS
	51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOg8Z01BgqEjm4XCZ9GVR5d0qhTM451v
	IFD8jveoK/uXSp/JZs7vvt1ay9Oj6dEd36rPOT1eudLYMyheXYtPKEb/eSJnckOO8WPH6th1
	yb4iC+9dCy3ZorzD/sDmVZs42UMfdx9YUn6whSd2z3Nv5QULJ8nmcNziV5lRnlvsobwm9N2V
	eVufKLEUZyQaajEXFScCANgwsRgSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQd1FTQpBBm8na1o8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5UUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMWbs27+SueCSdsXfTZkNjGuVuhg5OSQETCTW3VvBAmGLSVy4t56t
	i5GLQ0hgOqPEzz3tTBDOH0aJE00TmUGq2AS0JP6+eQNmiwh4SbzY/YAZpIhZ4BGTxN0ls5kh
	OvYwShy9dBhoLgcHp4CbxLelhiCmsECCxPkz+iC9LAKqEhMmrwSbwytgK9Fx6QmULSjxY/I9
	sIuYBQwk3s/qY4Ww5SU2r3nLDDJGQkBd4tFfXYgTjCR6Jk5ihigRkdj34h3jBEahWUgmzUIy
	aRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxWnknvYFzVYHGIUYCDUYmH
	t2GqfJAQa2JZcWXuIUYJDmYlEd6KVIUgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hpry8
	knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBkzIs5HCUaV7+h
	5kqvj1/P4W0s/Jf7KhWtO7La+Dk5uKUCCqK9GnnSvGXq/z+N9nn+JtK9f/aJlJWJjYvrrLgy
	ghViN5za0XRY0iMiKzLmpv5DlsvJWy9FmihaR+/f9IwjStbbbWe+U5Rel0Mq15XdaX3la/Pn
	n8iak33g1FKutzF8Vj/PKbEUZyQaajEXFScCAHHhOldvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Friday, August 30, 2013, Doug Anderson wrote:
> Previously the dw_mmc driver would ignore any requests to disable the
> card's clock.  This doesn't seem like a good thing in general, but had
> one extra bad side effect in the following situtation:
> * mmc core would set clk to 400kHz at boot time while initting
> * mmc core would set clk to 0 since no card, but it would be ignored.
> * suspend to ram and resume; clocks in the dw_mmc IP block are now 0
>   but dw_mmc thinks that they're 400kHz (it ignored the set to 0).
> * insert card
> * mmc core would set clk to 400kHz which would be considered a no-op.
> 
> Note that if there is no card in the slot and we do a suspend/resume
> cycle, we _do_ still end up with differences in a dw_mmc register
> dump, but the differences are clock related and we've got the clock
> disabled both before and after, so this should be OK.

I looked into this change with various kinds.
When we consider the SDIO, clock off may need to be cared.
As we know, because low power mode is off in case of SDIO,
there is no way to disable clock though '0' is requested for clock rate.
Ok, it would be better if some minor things below are applied.
I guess I can update those.

> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v7:
> - Avoid printing the same clock over and over again w/ MMC_CLKGATE.
> 
> Changes in v6:
> - Replaces previous pathes that ensured saving/restoring clocks.
> 
>  drivers/mmc/host/dw_mmc.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ee5f167..1584705 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -88,6 +88,8 @@ struct idmac_desc {
>   * @queue_node: List node for placing this node in the @queue list of
>   *	&struct dw_mci.
>   * @clock: Clock rate configured by set_ios(). Protected by host->lock.
> + * @last_printed_clock: The last clock we printed.  Keeping track of this helps
'last_printed_clock' can be changed to a nice name.

> + *	us to avoid spamming the console with CONFIG_MMC_CLKGATE.
>   * @flags: Random state bits associated with the slot.
>   * @id: Number of this slot.
>   * @last_detect_state: Most recently observed card detect state.
> @@ -105,6 +107,7 @@ struct dw_mci_slot {
>  	struct list_head	queue_node;
> 
>  	unsigned int		clock;
> +	unsigned int		last_printed_clock;
>  	unsigned long		flags;
>  #define DW_MMC_CARD_PRESENT	0
>  #define DW_MMC_CARD_NEED_INIT	1
> @@ -635,7 +638,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  	u32 div;
>  	u32 clk_en_a;
> 
> -	if (slot->clock != host->current_speed || force_clkinit) {
> +	if (slot->clock == 0) {
> +		mci_writel(host, CLKENA, 0);
> +		mci_send_cmd(slot,
> +			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
In the dw_mci_setup_bus(), above two lines related to clock-disable are necessary both if and else-if statement
That is it can be executed unconditionally.


> +	} else if (slot->clock != host->current_speed || force_clkinit) {
>  		div = host->bus_hz / slot->clock;
>  		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
>  			/*
> @@ -646,10 +653,14 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
> 
>  		div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
> 
> -		dev_info(&slot->mmc->class_dev,
> -			 "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
> -			 " div = %d)\n", slot->id, host->bus_hz, slot->clock,
> -			 div ? ((host->bus_hz / div) >> 1) : host->bus_hz, div);
> +		if (slot->clock != slot->last_printed_clock || force_clkinit) {
If 'bus_hz' or 'div' is different with old one as well, it should be considered.
'div' can be a good factor to compare this condition. Then 'last_printed_clock' should reflect clock divider.

Thanks,
Seungwon Jeon
> +			dev_info(&slot->mmc->class_dev,
> +				 "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ div = %d)\n",
> +				 slot->id, host->bus_hz, slot->clock,
> +				 div ? ((host->bus_hz / div) >> 1) :
> +				 host->bus_hz, div);
> +			slot->last_printed_clock = slot->clock;
> +		}
> 
>  		/* disable clock */
>  		mci_writel(host, CLKENA, 0);
> @@ -675,9 +686,8 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  		/* inform CIU */
>  		mci_send_cmd(slot,
>  			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
> -
> -		host->current_speed = slot->clock;
>  	}
> +	host->current_speed = slot->clock;
> 
>  	/* Set the current slot bus width */
>  	mci_writel(host, CTYPE, (slot->ctype << slot->id));
> @@ -807,13 +817,11 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> 
>  	mci_writel(slot->host, UHS_REG, regs);
> 
> -	if (ios->clock) {
> -		/*
> -		 * Use mirror of ios->clock to prevent race with mmc
> -		 * core ios update when finding the minimum.
> -		 */
> -		slot->clock = ios->clock;
> -	}
> +	/*
> +	 * Use mirror of ios->clock to prevent race with mmc
> +	 * core ios update when finding the minimum.
> +	 */
> +	slot->clock = ios->clock;
> 
>  	if (drv_data && drv_data->set_ios)
>  		drv_data->set_ios(slot->host, ios);
> --
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

