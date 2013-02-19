Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab3BSKEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:04:34 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:44383
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758564Ab3BSKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:04:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551bizbb2dI98dI9371Ida00hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1155h)
Message-ID: <51234E27.9020604@freescale.com>
Date: Tue, 19 Feb 2013 12:04:23 +0200
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
> +
> +#define PAACE_TCEF_FORMAT0_8B   0x00
> +#define PAACE_TCEF_FORMAT1_RSVD 0x01
> +
> +#define PAACE_NUMBER_ENTRIES    0x1FF

Where is this number coming from?

Diana



