Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3GOMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:09:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20269 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3GOMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:09:54 -0400
X-AuditID: cbfee68e-b7f276d000002279-05-51e3e691aaec
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1373470926-19314-3-git-send-email-dianders@chromium.org>
In-reply-to: <1373470926-19314-3-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v3 2/5] mmc: dw_mmc: Add suspend_noirq/resume_noirq
 callbacks for dw_mmc-pltfm
Date: Mon, 15 Jul 2013 21:09:53 +0900
Message-id: <004001ce8154$36753510$a35f9f30$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac59hEEAjATtZxCfR5qJ4+1zzo7o/ADy7a+w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zvu7EZ48DDbYfk7V4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2hx6vpnNotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZXxu7GYv
	eK9cMaNxJXsD427ZLkZODgkBE4kZPRdYIGwxiQv31rN1MXJxCAksY5Q4vuYbI0xR0+OnLBCJ
	6YwSpzqeMUE4fxglFq89xAxSxSagJfH3zRswW0TAS+LF7gfMIEXMAk+YJK59vAY2SkhgL6PE
	2SXlIDangJvE6Rf7wXYLC6RIzPv2iR3EZhFQlZh9fhEbiM0rYCuxY+9GZghbUOLH5Htg9cwC
	BhLvZ/WxQtjyEpvXvAWq4QA6VV3i0V9diBuMJDb8Xg5VLiKx78U7RpB7JARmckg079rBCrFL
	QOLb5EMsEL2yEpsOMEN8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGR
	XnFibnFpXrpecn7uJkZI9PftYLx5wPoQYzLQ+onMUqLJ+cDkkVcSb2hsZmRhamJqbGRuaUaa
	sJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRvZku3M7xDjnsRyquayyiavWceV0
	vla9Y7fv83Q+6ooJ7Fn57VPBhx7vvZ2XU7YI36+fFmIgGxRrz2EbOu21leuX/oQTS+4wn+H4
	ecvURkY1rj61mUlBS2LF7lrlqg5tn4A4drUDAaUbGOLfnV/vsLjhWPrnyyFx2yU3BJt3PbAW
	3qk4qemQEktxRqKhFnNRcSIAkVVODxQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jQd2Jzx4HGmy+LWHxeM1iJosH87ax
	WWx/vZHN4uyyg2wWr478YLJ4N+8Fs8WNX22sFpd3zWGzOPK/n9Hi1PXPbBardv1hdOD2mN1w
	kcVj56y77B49O88wehy6spbR48qJJlaPvi2rGD0+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3
	VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpSSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYx5jxubGbveC9csWMxpXsDYy7ZbsYOTkkBEwkmh4/ZYGwxSQu3FvP
	1sXIxSEkMJ1R4lTHMyYI5w+jxOK1h5hBqtgEtCT+vnkDZosIeEm82P2AGaSIWeAJk8S1j9cY
	QRJCAnsZJc4uKQexOQXcJE6/2A+2QlggRWLet0/sIDaLgKrE7POL2EBsXgFbiR17NzJD2IIS
	PybfA6tnFjCQeD+rjxXClpfYvOYtUA0H0KnqEo/+6kLcYCSx4fdyqHIRiX0v3jFOYBSahWTS
	LCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwanlmdQOxpUNFocYBTgY
	lXh4D2g8DhRiTSwrrsw9xCjBwawkwrv0IlCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84Fp
	L68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGKfM9eCvVFdN
	+2kkyWtUer9HsN61dbnBiqL+/1bTpoa9F0ooORZqsGHRl6Xbuy8fNJwssHPzMrGl4dXGVut/
	Gq55y3frSXem5w0dX/1r6xe6OglxXcz8dvZNt8mV38uXXD09P3fXbYHVzSZHrXoTghidj55w
	rSk0j46WPhaydqWJ6P7pHrLlp5VYijMSDbWYi4oTAcVUqHpxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, July 11, 2013, Doug Anderson wrote:
> On some devices (like exynos5420) the dw_mmc controller may be in a
> strange state after we wake up from sleep.  Add callbacks to allow for
> dealing with these quirks.  We use the "_noirq" versions of the
> callbacks since in the case of exynos5420 the strange state caused
> interrupts to fire so we need to deal with it while interrupts are
> still off.
> 
> At the moment this support is only added to dw_mmc-pltfm which calls
> straight to the callback, since nobody but exynos needs it.  We can
> add some levels of indirection (a call into the generic dw_mmc code)
> when someone finds a need.
I think It would be better to add _noirq only to dw_mmc-exynos.
That is we can add dev_pm_ops for dw_mmc-exynos's own.
As you recognize, there is no common routine which is not introduced for dw_mmc xxx_noirq now.
I feel like it is for handling quirk.
If we meet use case for that in some day, it could be added commonly.
How do you think?

Thanks,
Seungwon Jeon
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: James Hogan <james.hogan@imgtec.com>
> ---
> Changes in v3:
> - Add freeze/thaw and poweroff/restore noirq entries.
> 
> Changes in v2:
> - Use suspend_noirq as per James Hogan.
> 
>  drivers/mmc/host/dw_mmc-pltfm.c | 41 ++++++++++++++++++++++++++++++++++++++---
>  drivers/mmc/host/dw_mmc.h       |  4 ++++
>  2 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index 41c27b7..742ef76 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -105,12 +105,47 @@ static int dw_mci_pltfm_resume(struct device *dev)
> 
>  	return 0;
>  }
> +
> +static int dw_mci_pltfm_suspend_noirq(struct device *dev)
> +{
> +	struct dw_mci *host = dev_get_drvdata(dev);
> +	const struct dw_mci_drv_data *drv_data = host->drv_data;
> +
> +	if (drv_data && drv_data->suspend_noirq)
> +		return drv_data->suspend_noirq(host);
> +
> +	return 0;
> +}
> +
> +static int dw_mci_pltfm_resume_noirq(struct device *dev)
> +{
> +	struct dw_mci *host = dev_get_drvdata(dev);
> +	const struct dw_mci_drv_data *drv_data = host->drv_data;
> +
> +	if (drv_data && drv_data->resume_noirq)
> +		return drv_data->resume_noirq(host);
> +
> +	return 0;
> +}
> +
> +
>  #else
> -#define dw_mci_pltfm_suspend	NULL
> -#define dw_mci_pltfm_resume	NULL
> +#define dw_mci_pltfm_suspend		NULL
> +#define dw_mci_pltfm_resume		NULL
> +#define dw_mci_pltfm_suspend_noirq	NULL
> +#define dw_mci_pltfm_resume_noirq	NULL
>  #endif /* CONFIG_PM_SLEEP */
> 
> -SIMPLE_DEV_PM_OPS(dw_mci_pltfm_pmops, dw_mci_pltfm_suspend, dw_mci_pltfm_resume);
> +const struct dev_pm_ops dw_mci_pltfm_pmops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dw_mci_pltfm_suspend, dw_mci_pltfm_resume)
> +	.suspend_noirq = dw_mci_pltfm_suspend_noirq,
> +	.resume_noirq = dw_mci_pltfm_resume_noirq,
> +	.freeze_noirq = dw_mci_pltfm_suspend_noirq,
> +	.thaw_noirq = dw_mci_pltfm_resume_noirq,
> +	.poweroff_noirq = dw_mci_pltfm_suspend_noirq,
> +	.restore_noirq = dw_mci_pltfm_resume_noirq,
> +};
> +
>  EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
> 
>  static const struct of_device_id dw_mci_pltfm_match[] = {
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 0b74189..5d0398f 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -190,6 +190,8 @@ extern int dw_mci_resume(struct dw_mci *host);
>   * @prepare_command: handle CMD register extensions.
>   * @set_ios: handle bus specific extensions.
>   * @parse_dt: parse implementation specific device tree properties.
> + * @suspend_noirq: called late in the suspend process
> + * @resume_noirq: called early in the resume process
>   *
>   * Provide controller implementation specific extensions. The usage of this
>   * data structure is fully optional and usage of each member in this structure
> @@ -202,5 +204,7 @@ struct dw_mci_drv_data {
>  	void		(*prepare_command)(struct dw_mci *host, u32 *cmdr);
>  	void		(*set_ios)(struct dw_mci *host, struct mmc_ios *ios);
>  	int		(*parse_dt)(struct dw_mci *host);
> +	int		(*suspend_noirq)(struct dw_mci *host);
> +	int		(*resume_noirq)(struct dw_mci *host);
>  };
>  #endif /* _DW_MMC_H_ */
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

