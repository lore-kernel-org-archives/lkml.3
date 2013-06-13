Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130Ab3FMSon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:44:43 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:62654 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab3FMSol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:44:41 -0400
Date: Thu, 13 Jun 2013 11:17:59 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Oded Gabbay <ogabbay@advaoptical.com>
Cc: cjb@laptop.org, shawn.guo@linaro.org, Chang-Ming.Huang@freescale.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MMC: P2020 SDHC: Add support for 8-bit bus width and
 non-removable card
Message-ID: <20130613181759.GA27040@teo>
References: <1371045205-3164-1-git-send-email-ogabbay@advaoptical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1371045205-3164-1-git-send-email-ogabbay@advaoptical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:53:25PM +0300, Oded Gabbay wrote:
> @@ -262,7 +288,23 @@ static const struct sdhci_pltfm_data sdhci_esdhc_pdata = {
>  
>  static int sdhci_esdhc_probe(struct platform_device *pdev)
>  {
> -	return sdhci_pltfm_register(pdev, &sdhci_esdhc_pdata);
> +	struct sdhci_host *host;
> +	int ret = 0;

No need for the 0 initializer.

Otherwise it looks OK, thanks!

Reviewed-by: Anton Vorontsov <anton@enomsg.org>
