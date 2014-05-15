Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaEOGeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:34:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34683 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaEOGeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:34:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Simon Horman" <horms@verge.net.au>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140515161121.39998223@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wolfram Sang" <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20140515161121.39998223@canb.auug.org.au>
Message-ID: <20140515063355.9521.79464@quantum>
User-Agent: alot/0.3.5
Subject: Re: linux-next: manual merge of the clk tree with the renesas tree
Date: Wed, 14 May 2014 23:33:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (2014-05-14 23:11:21)
> Hi Mike,
> 
> Today's linux-next merge of the clk tree got a conflict in
> Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> between commit b557deadc5cc ("ARM: shmobile: r7s72100: document MSTP
> clock support") from the renesas tree and commit 5483bf698f42 ("clk:
> shmobile: r8a7779: Add MSTP clock support") from the clk tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Stephen,

Your fix is correct, per Geert's email in another thread[1].

Regards,
Mike

[1] http://www.spinics.net/lists/linux-sh/msg31748.html

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> index b5fc72621bfd,30df825d72ef..000000000000
> --- a/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> +++ b/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
> @@@ -10,7 -10,7 +10,8 @@@ index in the group, from 0 to 31
>   Required Properties:
>   
>     - compatible: Must be one of the following
>  +    - "renesas,r7s72100-mstp-clocks" for R7S72100 (RZ) MSTP gate clocks
> +     - "renesas,r8a7779-mstp-clocks" for R8A7779 (R-Car H1) MSTP gate clocks
>       - "renesas,r8a7790-mstp-clocks" for R8A7790 (R-Car H2) MSTP gate clocks
>       - "renesas,r8a7791-mstp-clocks" for R8A7791 (R-Car M2) MSTP gate clocks
>       - "renesas,cpg-mstp-clock" for generic MSTP gate clocks
