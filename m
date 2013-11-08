Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3KHJMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:12:34 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50579 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3KHJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:12:28 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] devicetree: bindings: Document cpu enable-method for ARM CPUs
Date: Fri, 08 Nov 2013 10:12:27 +0100
Message-ID: <2530561.EJ90QlWNJQ@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383343739-23080-2-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 of November 2013 15:08:49 Stephen Boyd wrote:
> From: Rohit Vaswani <rvaswani@codeaurora.org>
> 
> According to the ePAPR CPUs should have an enable method. On ARM
> the enable-method property has not been used so far, so document
> this property as an optional property and add the spin-table
> method as one value
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> [sboyd: Split off into separate patch]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt
> b/Documentation/devicetree/bindings/arm/cpus.txt index f32494d..37258f9
> 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -45,6 +45,14 @@ For the ARM architecture every CPU node must contain
> the following properties: "marvell,xsc3"
>  		"marvell,xscale"
> 
> +And the following optional properties:
> +
> +- enable-method: Specifies the method used to enable or take the
> secondary cores +		 out of reset. This allows different reset 
sequence
> for
> +		 different types of cpus.
> +		 This should be one of:
> +		 "spin-table"

What about saying a word or two (other than property value) about each 
method?

Best regards,
Tomasz

