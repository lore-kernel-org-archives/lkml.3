Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbaDIN72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:59:28 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:52874 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <1397051478-4113-7-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-7-git-send-email-boris.brezillon@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 9 Apr 2014 21:59:02 +0800
X-Google-Sender-Auth: BVjXjbQXAvcj9bgTZ1rj3lI6KTk
Message-ID: <CAGb2v645Yu_1ODQhVcQjjFf1M0uf3aHBfRw4F_uhoYk9RozcOA@mail.gmail.com>
Subject: Re: [PATCH 06/15] clk: sunxi: add A31 APB0 gates compatible string to
 the documentation
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 9, 2014 at 9:51 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:
> Add the new "allwinner,sun6i-a31-apb0-gates-clk" compatible string to the
> sunxi clock documentation.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
> index c2cb762..bc30387 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -25,6 +25,7 @@ Required properties:
>         "allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
>         "allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
>         "allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
> +       "allwinner,sun6i-a31-apb0-gates-clk" - for the APB0 gates on A10s
                                                                       ^^^^
Copy paste error here.


ChenYu

>         "allwinner,sun7i-a20-apb0-gates-clk" - for the APB0 gates on A20
>         "allwinner,sun4i-apb1-clk" - for the APB1 clock
>         "allwinner,sun4i-apb1-mux-clk" - for the APB1 clock muxing
