Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3FGFfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:35:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23834 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3FGFfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:35:42 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-a3-51b1712c1749
Message-id: <51B1712C.5030705@samsung.com>
Date: Fri, 07 Jun 2013 14:35:40 +0900
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
        Will Newton <will.newton@imgtec.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Add the ability to set the ciu clock
 frequency
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
 <1370580406-10254-2-git-send-email-dianders@chromium.org>
In-reply-to: <1370580406-10254-2-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSoqtbuDHQoGMei8XjNYuZLFa+/8to
	8WDeNjaL7a83slkcmP2Q1eLssoNA1p8djBY3frWxWixsW8JicXnXHDaLI//7GS1OXf/MZnF4
	xQEmi3Uvp7NYfLh/kdli1a4/jBZ/+nayOAh6LPh8hd1jdsNFFo+ds+6ye/TsPMPo8Wr1TFaP
	Q1fWMnrcubaHzeP8jIWMHldONLF69G1ZxejxeZNcAHcUl01Kak5mWWqRvl0CV0bXt8lMBVNl
	K7onyTQwzhLvYuTgkBAwkdi/3q6LkRPIFJO4cG89WxcjF4eQwFJGiU0L1zPC1Fxo5IOIT2eU
	6LnzjB3CeckoMeXYVCaQbl4BLYk5va9YQGwWAVWJpz9OsoLYbAI6Etu/HQerERUIk9jU0wxV
	LyjxY/I9sHoRAU2JZw0vmUGGMgucYZHYeG0ZWJEwUMPhaxMYIbY1Mkrc+beWGSTBKeAm0Xvv
	CjuIzQy0YX/rNDYIW15i85q3YJMkBE5wSKw7doQJ4iQBiW+TD7FA/CMrsekAM8TPkhIHV9xg
	mcAoNgvJUbOQjJ2FZOwCRuZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGIFp4fS/Z707GG8f
	sD7EmAy0ciKzlGhyPjCt5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBMU7z1PETR36VhO/+NWmrWtV710MW98uu8utoHep/cSEwhfNEh3ZKWd2T
	Ay51fY29y+anrEzqzHp2ZqXnjAfTXYxn3dCSflIb9yqFOTF3rl03w5Gfuxlm172OFdFPY83z
	SuM89VvE8tY6ls+a5VfW3lh9p2v1Yi/XJe/qjeKnsuYut824ZbDhrBJLcUaioRZzUXEiAByB
	/ichAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jQV2dwo2BBr3/zC0er1nMZLHy/V9G
	iwfztrFZbH+9kc3iwOyHrBZnlx0Esv7sYLS48auN1WJh2xIWi8u75rBZHPnfz2hx6vpnNovD
	Kw4wWax7OZ3F4sP9i8wWq3b9YbT407eTxUHQY8HnK+wesxsusnjsnHWX3aNn5xlGj1erZ7J6
	HLqyltHjzrU9bB7nZyxk9LhyoonVo2/LKkaPz5vkArijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D+UlIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmdH2bzFQwVbaie5JMA+Ms8S5GDg4JAROJC418XYycQKaYxIV769m6
	GLk4hASmM0r03HnGDuG8ZJSYcmwqE0gVr4CWxJzeVywgNouAqsTTHydZQWw2AR2J7d+Og9WI
	CoRJbOpphqoXlPgx+R5YvYiApsSzhpfMIEOZBc6wSGy8tgysSBio4fC1CYwQ2xoZJe78W8sM
	kuAUcJPovXeFHcRmBtqwv3UaG4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxgtPOM+kdjKsaLA4xCnAwKvHw/li1IVCINbGsuDL3EKMEB7OSCO/6
	tI2BQrwpiZVVqUX58UWlOanFhxiTgWEwkVlKNDkfmBLzSuINjU3MjCyNzA0tjIzNSRNWEuc9
	2GodKCSQnliSmp2aWpBaBLOFiYNTqoGxs67rbdWr3zE8s7b7cczcrL3U5WzDZVHXwrz2tozs
	y9Mqr+cYNaw38/kitSFcwiKU51j6dNO+3Qemm/wW5W3i2Xj+lXjuvSmzOR5ae7vmvCl7Ot3x
	7eRuvwuTIlkv86ya7ySx0bXs+Ylf0SIPt/8XU2xvXlOarOrFe0n59Nutyy65BvwQ33FQiaU4
	I9FQi7moOBEACecnOH8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. If you can add the usage example, it will be more helpful to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 06/07/2013 01:46 PM, Doug Anderson wrote:
> As of now we rely on code outside of the driver to set the ciu clock
> frequency.  There's no reason to do that.  Add support for setting up
> the clock in the driver during probe.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  .../devicetree/bindings/mmc/synopsis-dw-mshc.txt        | 13 +++++++++++++
>  drivers/mmc/host/dw_mmc.c                               | 17 +++++++++++++----
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> index b09d2d0..edb7659 100644
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
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index d3a0f8a..7ffb502 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2133,6 +2133,7 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  	struct device_node *np = dev->of_node;
>  	const struct dw_mci_drv_data *drv_data = host->drv_data;
>  	int idx, ret;
> +	u32 clock_frequency;
>  
>  	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>  	if (!pdata) {
> @@ -2159,6 +2160,9 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  
>  	of_property_read_u32(np, "card-detect-delay", &pdata->detect_delay_ms);
>  
> +	if (!of_property_read_u32(np, "clock-frequency", &clock_frequency))
> +		pdata->bus_hz = clock_frequency;
> +
>  	if (drv_data && drv_data->parse_dt) {
>  		ret = drv_data->parse_dt(host);
>  		if (ret)
> @@ -2223,18 +2227,23 @@ int dw_mci_probe(struct dw_mci *host)
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

