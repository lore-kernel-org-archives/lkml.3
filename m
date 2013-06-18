Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab3FREv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:51:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17912 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3FREvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:51:24 -0400
X-AuditID: cbfee68f-b7f436d000000f81-bb-51bfe74a5aa5
Message-id: <51BFE754.6000909@samsung.com>
Date: Tue, 18 Jun 2013 13:51:32 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mmc: dw_mmc: Add the ability to set the ciu clock
 frequency
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
 <1370626110-1731-1-git-send-email-dianders@chromium.org>
 <1370626110-1731-2-git-send-email-dianders@chromium.org>
In-reply-to: <1370626110-1731-2-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSouv1fH+gwbvnuhaP1yxmslj5/i+j
	xYN529gstr/eyGZxYPZDVouzyw4CWX92MFrc+NXGarGwbQmLxeVdc9gsjvzvZ7Q4df0zm8Xh
	FQeYLNa9nM5i8eH+RWaLVbv+MFos3HSIzUHQY8HnK+wesxsusnjsnHWX3ePV6pmsHoeurGX0
	uHNtD5vH+RkLGT2unGhi9ejbsorR4/MmuQCuKC6blNSczLLUIn27BK6MW3d2sxS8UK74su4d
	UwPjapkuRk4OCQETifU3l7BD2GISF+6tZ+ti5OIQEljKKPGifRUzTNHTrnYWiMQiRoltZ6ZB
	Vb1klLhzehcrSBWvgJbEptkH2UBsFgFViT+flrCA2GwCOhLbvx1nArFFBcIkNvU0M0HUC0r8
	mHwPrEZEQFPiWcNLZpChzAKnWSTeHHsGViQsECmxa9oysDOEBHYDbftjB2JzCrhK/D3RBRZn
	Blqwv3UaG4QtL7F5zVuwQRICezgkpu/ewgpxkYDEt8mHgLZxACVkJTYdgHpNUuLgihssExjF
	ZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzAhnP73rH8H490D1ocY
	k4FWTmSWEk3OByaUvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNS
	iw8xMnFwSjUw8nAFfc5qqJHMuzl1J7feGYML+zf1OtmHRKx7H/NCIaRh4enOJ7zZPz0sM0Nn
	mC02Wv9qx7/81QcXzj6sXXr/m86Zd0eaFRxvP9y5tJS5dJ1u6636aXs9Fr7ROZFxnEtj9u4u
	XkuWp20Mk7PuJ35v2KhdryIS8SRs7cNa69brYnOUeY9HOty+p8RSnJFoqMVcVJwIALc+52ce	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jAV2v5/sDDZ68VrZ4vGYxk8XK938Z
	LR7M28Zmsf31RjaLA7MfslqcXXYQyPqzg9Hixq82VouFbUtYLC7vmsNmceR/P6PFqeuf2SwO
	rzjAZLHu5XQWiw/3LzJbrNr1h9Fi4aZDbA6CHgs+X2H3mN1wkcVj56y77B6vVs9k9Th0ZS2j
	x51re9g8zs9YyOhx5UQTq0ffllWMHp83yQVwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8eb
	mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAvaSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zck
	CK7HyAANJKxhzLh1ZzdLwQvlii/r3jE1MK6W6WLk5JAQMJF42tXOAmGLSVy4t56ti5GLQ0hg
	EaPEtjPToJyXjBJ3Tu9iBaniFdCS2DT7IBuIzSKgKvHn0xKwbjYBHYnt344zgdiiAmESm3qa
	mSDqBSV+TL4HViMioCnxrOElM8hQZoHTLBJvjj0DKxIWiJTYNW0ZM4gtJLAbaNsfOxCbU8BV
	4u+JLrA4M9CC/a3T2CBseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJEZxunkntYFzZYHGIUYCDUYmHN0Fsf6AQa2JZcWXuIUYJDmYlEd6SM0Ah3pTE
	yqrUovz4otKc1OJDjMnAIJjILCWanA9MhXkl8YbGJmZGlkbmhhZGxuakCSuJ8x5otQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwKiWczTmrVr40oi1n15ZqpSWh3kFXdwme/Lg8/cduZX9j8s25Bg0
	JKtttlpypjRBaWK1h4ZCSYCxH1+IuIB4+OLDDD6X0kvZlpSX75p93HT6b31rXfHWU3djeJbs
	7Ihh+1F5aq1gW9ON+xrbgmef+J5qblHYcGD20TymN5KX7dJ9r9w/y5pcr8RSnJFoqMVcVJwI
	ANWBEUt7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

I have one question for using <clock-frequency>.
I found the fixed-rate-clocks feature.
If we want to set <clock-frequency>, then can we use the fixed-rate-clocks?
i'm not sure how use the fixed-rate-clocks. but it seems to set fixed-rate value for clock frequency.

clk_set_rate() didn't ensure to set the <clock-frequency> value.

Best Regards,
Jaehoon Chung

On 06/08/2013 02:28 AM, Doug Anderson wrote:
> As of now we rely on code outside of the driver to set the ciu clock
> frequency.  There's no reason to do that.  Add support for setting up
> the clock in the driver during probe.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
> ---
> Changes in v2:
> - Added example as per Jaehoon.
> 
>  .../devicetree/bindings/mmc/synopsis-dw-mshc.txt        | 16 ++++++++++++++++
>  drivers/mmc/host/dw_mmc.c                               | 17 +++++++++++++----
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> index d5cc94e..dd31b00 100644
> --- a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> @@ -39,6 +39,19 @@ Required Properties:
>  
>  Optional properties:
>  
> +* clocks: from common clock binding: handle to biu and ciu clocks for the
> +  bus interface unit clock and the card interface unit clock.
> +
> +* clock-names: from common clock binding: Shall be "biu" and "ciu".
> +  If the biu clock is missing we'll simply skip enabling it.  If the
> +  ciu clock is missing we'll just assume that the clock is running at
> +  clock-frequency.  It is an error to omit both the ciu clock and the
> +  clock-frequency.
> +
> +* clock-frequency: should be the frequency (in Hz) of the ciu clock.  If this
> +  is specified and the ciu clock is specified then we'll try to set the ciu
> +  clock to this at probe time.
> +
>  * num-slots: specifies the number of slots supported by the controller.
>    The number of physical slots actually used could be equal or less than the
>    value specified by num-slots. If this property is not specified, the value
> @@ -70,6 +83,8 @@ board specific portions as listed below.
>  
>  	dwmmc0@12200000 {
>  		compatible = "snps,dw-mshc";
> +		clocks = <&clock 351>, <&clock 132>;
> +		clock-names = "biu", "ciu";
>  		reg = <0x12200000 0x1000>;
>  		interrupts = <0 75 0>;
>  		#address-cells = <1>;
> @@ -77,6 +92,7 @@ board specific portions as listed below.
>  	};
>  
>  	dwmmc0@12200000 {
> +		clock-frequency = <400000000>;
>  		num-slots = <1>;
>  		supports-highspeed;
>  		broken-cd;
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ab5642d..b8a2f16 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2107,6 +2107,7 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  	struct device_node *np = dev->of_node;
>  	const struct dw_mci_drv_data *drv_data = host->drv_data;
>  	int idx, ret;
> +	u32 clock_frequency;
>  
>  	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>  	if (!pdata) {
> @@ -2133,6 +2134,9 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  
>  	of_property_read_u32(np, "card-detect-delay", &pdata->detect_delay_ms);
>  
> +	if (!of_property_read_u32(np, "clock-frequency", &clock_frequency))
> +		pdata->bus_hz = clock_frequency;
> +
>  	if (drv_data && drv_data->parse_dt) {
>  		ret = drv_data->parse_dt(host);
>  		if (ret)
> @@ -2190,18 +2194,23 @@ int dw_mci_probe(struct dw_mci *host)
>  	host->ciu_clk = devm_clk_get(host->dev, "ciu");
>  	if (IS_ERR(host->ciu_clk)) {
>  		dev_dbg(host->dev, "ciu clock not available\n");
> +		host->bus_hz = host->pdata->bus_hz;
>  	} else {
>  		ret = clk_prepare_enable(host->ciu_clk);
>  		if (ret) {
>  			dev_err(host->dev, "failed to enable ciu clock\n");
>  			goto err_clk_biu;
>  		}
> -	}
>  
> -	if (IS_ERR(host->ciu_clk))
> -		host->bus_hz = host->pdata->bus_hz;
> -	else
> +		if (host->pdata->bus_hz) {
> +			ret = clk_set_rate(host->ciu_clk, host->pdata->bus_hz);
> +			if (ret)
> +				dev_warn(host->dev,
> +					 "Unable to set bus rate to %ul\n",
> +					 host->pdata->bus_hz);
> +		}
>  		host->bus_hz = clk_get_rate(host->ciu_clk);
> +	}
>  
>  	if (drv_data && drv_data->setup_clock) {
>  		ret = drv_data->setup_clock(host);
> 

