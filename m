Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3LDGMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:12:55 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:32964 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174Ab3LDGMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:12:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Wed, 4 Dec 2013 13:43:42 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] usb: chipidea: msm: Initialize offset of the
 capability registers
Message-ID: <20131204054341.GC29552@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
 <1384176937-1658-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1384176937-1658-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 03:35:36PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 

The commit log is needed.

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/chipidea/ci_hdrc_msm.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> index 747d6c1..e9624f3 100644
> --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> @@ -47,6 +47,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
>  
>  static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
>  	.name			= "ci_hdrc_msm",
> +	.capoffset		= DEF_CAPOFFSET,
>  	.flags			= CI_HDRC_REGS_SHARED |
>  				  CI_HDRC_REQUIRE_TRANSCEIVER |
>  				  CI_HDRC_DISABLE_STREAMING,
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Best Regards,
Peter Chen

