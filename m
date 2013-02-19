Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3BSP7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:59:49 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:2651 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932382Ab3BSP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:59:48 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551bizbb2dI98dI9371Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1155h)
Message-ID: <5123A169.9060100@freescale.com>
Date: Tue, 19 Feb 2013 17:59:37 +0200
From: Diana Craciun <diana.craciun@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <joro@8bytes.org>, <stuart.yoder@freescale.com>
Subject: Re: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com> <1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 02:52 PM, Varun Sethi wrote:
> +/**
> + * pamu_get_ppaace() - Return the primary PACCE
> + * @liodn: liodn PAACT index for desired PAACE
> + *
> + * Returns the ppace pointer upon success else return
> + * null.
> + */
> +static struct paace *pamu_get_ppaace(int liodn)
> +{
> +	if (!ppaact || liodn > PAACE_NUMBER_ENTRIES) {

Shouldn't be "liodn >= PAACE_NUMBER_ENTRIES" ?

> +		pr_err("PPAACT doesn't exist\n");
> +		return NULL;
> +	}
> +
> +	return &ppaact[liodn];
> +}
> +

Diana

