Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212AbaKNL0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:26:00 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:41722 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934404AbaKNLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:25:58 -0500
Date: Fri, 14 Nov 2014 12:25:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/4] of: Add vendor prefix for MIPS Technologies, Inc.
Message-ID: <20141114112541.GA11666@linux-mips.org>
References: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
 <1415821419-26974-2-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415821419-26974-2-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:43:36AM -0800, Andrew Bresticker wrote:

> Add the vendor prefix "mti" for MIPS Technologies, Inc.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'll update the users of the "mips" prefix to use "mti" instead once
> this lands.
> 
> No changes from v2/v3/v4.
> New for v2.
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 0979393..0221b49 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -98,6 +98,7 @@ mitsubishi	Mitsubishi Electric Corporation
>  mosaixtech	Mosaix Technologies, Inc.
>  moxa	Moxa
>  mpl	MPL AG
> +mti	MIPS Technologies, Inc.
>  mundoreader	Mundo Reader S.L.
>  murata	Murata Manufacturing Co., Ltd.
>  mxicy	Macronix International Co., Ltd.

Your patch does almost the same as

  https://patchwork.linux-mips.org/patch/8169/

which I already applied and which adds:

+mti    Imagination Technologies Ltd. (formerly MIPS Technologies Inc.)

  Ralf
