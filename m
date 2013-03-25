Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3CYJ3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:29:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25894 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3CYJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:29:18 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-d4-515018ed9193
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Felipe Balbi'" <balbi@ti.com>
Cc: "'Alexander Graf'" <agraf@suse.de>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1363305555-3544-1-git-send-email-dianders@chromium.org>
 <1363317337-7316-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363317337-7316-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
Date: Mon, 25 Mar 2013 18:29:17 +0900
Message-id: <176701ce293b$38b41ba0$aa1c52e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hK2rV5F1YB3cSTviXVoYZPFB0PwID7EHw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zke5biYBAg3U7lSxOXPnHaHHwfr3F
	y0OaFmeXHWSzaLtykN2iefF6NovLCy+xWlzeNYfNYtGyVmaLCb8vsFkcm7GE0YHbY3bDRRaP
	O9f2sHnsn7uG3WP23R+MHn1bVjF6bD5d7XH8xnYmj8+b5AI4orhsUlJzMstSi/TtErgyjlw8
	wVpwnadi0dl7jA2Ms7m6GDk5JARMJDr/r2CBsMUkLtxbz9bFyMUhJLCMUeLqpY+MMEXNX+ex
	QCQWMUrM3vWdGSQhJPCXUeLmSX4Qm01AQ+Lw+2fsILaIgJfExzN32EEamAUOMkmc27SJDaKh
	XuLgpa1gUzkFXCW2dGxgBbGFBXwllkzdCjaURUBVYt3WO2A1vAK2EivWT4WyBSV+TL4Hdiqz
	gJbE+p3HmSBseYnNa94C9XIAXaou8eivLsQNRhKvp/2AKhGR2PfiHSPIPRICczkkvuzuZIHY
	JSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3I
	VK84Mbe4NC9dLzk/dxMjJP4n7mC8f8D6EGMy0PqJzFKiyfnA9JFXEm9obGZkYWpiamxkbmlG
	mrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbkuldlzltWeV7y8HP5/CHXfc8n
	+S7vab+eXfz9NjpIwU69a5GZv5d6yJunnG631vy58yHVWnPubTH1A9uUmXMzSxL6Jmfa60xP
	bfnWV6xWIz1df+tctQcnzZMXHdhSaTdb5WtGhEb00pQjBU0bmluUstl+LZ35VH95175MM/1U
	7ZyHLx7cWazEUpyRaKjFXFScCABnkqeMFQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAd23EgGBBg8ny1qcuPKP0eLg/XqL
	l4c0Lc4uO8hm0XblILtF8+L1bBaXF15itbi8aw6bxaJlrcwWE35fYLM4NmMJowO3x+yGiywe
	d67tYfPYP3cNu8fsuz8YPfq2rGL02Hy62uP4je1MHp83yQVwRDUw2mSkJqakFimk5iXnp2Tm
	pdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA3amkUJaYUwoUCkgsLlbSt8M0ITTE
	TdcCpjFC1zckCK7HyAANJKxjzDhy8QRrwXWeikVn7zE2MM7m6mLk5JAQMJFo/jqPBcIWk7hw
	bz1bFyMXh5DAIkaJ2bu+M4MkhAT+MkrcPMkPYrMJaEgcfv+MHcQWEfCS+HjmDjtIA7PAQSaJ
	c5s2sUE01EscvLSVEcTmFHCV2NKxgRXEFhbwlVgydSvYUBYBVYl1W++A1fAK2EqsWD8VyhaU
	+DH5HthFzAJaEut3HmeCsOUlNq95C9TLAXSpusSjv7oQNxhJvJ72A6pERGLfi3eMExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnByeSa1g3Flg8UhRgEO
	RiUeXoEa/0Ah1sSy4srcQ4wSHMxKIrxaQgGBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwP
	THx5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4OPLywu63
	vz0vW1X82yqmGDkvznLBtHa3VbuOquic79WKjfHpv/j656W7eiIB02oZ7blOa13RlVCc8HLR
	V+1dkcFvj2QmrKu/q390v1ehw+8qnollTz7uqzaYr7zQN/BL2NEf/957TfzCUMpRX/tHl4Ez
	7A9n79158v96U0ozPs/7Lh7zZdFuJZbijERDLeai4kQAAMw9nXIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> The ehci_vbus_gpio is requested but never freed.  This can cause
> problems with deferred probes and would cause problems if
> s5p_ehci_remove was ever called.  Use devm to fix this.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

> ---
> Changes in v2:
> - &pdev->dev => dev elsewhere in s5p_setup_vbus_gpio()
> 
>  drivers/usb/host/ehci-s5p.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 20ebf6a..738490e 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -92,20 +92,21 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd
> *s5p_ehci)
> 
>  static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>  {
> +	struct device *dev = &pdev->dev;
>  	int err;
>  	int gpio;
> 
> -	if (!pdev->dev.of_node)
> +	if (!dev->of_node)
>  		return;
> 
> -	gpio = of_get_named_gpio(pdev->dev.of_node,
> -			"samsung,vbus-gpio", 0);
> +	gpio = of_get_named_gpio(dev->of_node, "samsung,vbus-gpio", 0);
>  	if (!gpio_is_valid(gpio))
>  		return;
> 
> -	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> +	err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
> +				    "ehci_vbus_gpio");
>  	if (err)
> -		dev_err(&pdev->dev, "can't request ehci vbus gpio %d",
gpio);
> +		dev_err(dev, "can't request ehci vbus gpio %d", gpio);
>  }
> 
>  static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
> --
> 1.8.1.3

