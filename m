Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3JHNDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:03:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37963 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab3JHNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:03:48 -0400
Date: Tue, 8 Oct 2013 14:03:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Documentation: add moxa vendor prefix
Message-ID: <20131008130318.GB1412@e106331-lin.cambridge.arm.com>
References: <1381237000-8398-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381237000-8398-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:56:40PM +0100, Jonas Jensen wrote:
> Add moxa vendor prefix.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Submitting this per Mark Rutland's request.
>     
>     Applies to next-20130927
> 
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 2956800..0a04e89 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -40,6 +40,7 @@ marvell	Marvell Technology Group Ltd.
>  maxim	Maxim Integrated Products
>  microchip	Microchip Technology Inc.
>  mosaixtech	Mosaix Technologies, Inc.
> +moxa	Moxa Technology Co., Ltd.

Should this not be Moxa _Technologies_ Co., Ltd? (judging by a quick
search).

Otherwise, this looks fine to me.

Mark.

>  national	National Semiconductor
>  nintendo	Nintendo
>  nvidia	NVIDIA
> -- 
> 1.8.2.1
> 
> 
