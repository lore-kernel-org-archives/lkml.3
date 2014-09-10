Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaIJQ5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:57:07 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61791 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaIJQ5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:57:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Simon Horman" <horms@verge.net.au>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140910173335.594bf533@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ulrich Hecht" <ulrich.hecht+renesas@gmail.com>
References: <20140910173335.594bf533@canb.auug.org.au>
Message-ID: <20140910165649.19023.66202@quantum>
User-Agent: alot/0.3.5
Subject: Re: linux-next: manual merge of the clk tree with the renesas tree
Date: Wed, 10 Sep 2014 09:56:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (2014-09-10 00:33:35)
> Hi Mike,
> 
> Today's linux-next merge of the clk tree got a conflict in
> Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> between commit b32c44b93af3 ("clk: shmobile: Add r8a7740, sh73a0 SoCs
> to MSTP bindings") from the renesas tree and commit 5acb7bbbab7c ("ARM:
> shmobile: r8a7794: document MSTP clock support") from the clk tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

We expected this, since the r8a7794 clock stuff is going through the
renesas tree. Looks good to me.

Thanks,
Mike

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> index 8f1424f0fa43,a03c8c029a94..000000000000
> --- a/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> +++ b/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> @@@ -15,7 -14,7 +15,8 @@@ Required Properties
>       - "renesas,r8a7779-mstp-clocks" for R8A7779 (R-Car H1) MSTP gate clocks
>       - "renesas,r8a7790-mstp-clocks" for R8A7790 (R-Car H2) MSTP gate clocks
>       - "renesas,r8a7791-mstp-clocks" for R8A7791 (R-Car M2) MSTP gate clocks
> +     - "renesas,r8a7794-mstp-clocks" for R8A7794 (R-Car E2) MSTP gate clocks
>  +    - "renesas,sh73a0-mstp-clocks" for SH73A0 (SH-MobileAG5) MSTP gate clocks
>       - "renesas,cpg-mstp-clock" for generic MSTP gate clocks
>     - reg: Base address and length of the I/O mapped registers used by the MSTP
>       clocks. The first register is the clock control register and is mandatory.
