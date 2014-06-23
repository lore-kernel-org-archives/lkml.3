Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaFWDXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:23:34 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47670 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaFWDXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:23:31 -0400
MIME-Version: 1.0
In-Reply-To: <1403486483-4063-3-git-send-email-afaerber@suse.de>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
	<1403486483-4063-3-git-send-email-afaerber@suse.de>
Date: Mon, 23 Jun 2014 08:53:29 +0530
X-Google-Sender-Auth: l0N4b4RwY8jPT4fyNfnZP7cKjCI
Message-ID: <CAK5sBcFg8t_e5LLHp3MGv8xJq6gC6Eb_KQqoPG2yq2ajejCU2w@mail.gmail.com>
Subject: Re: [PATCH 2/4] Documentation: devicetree: Fix s2mps11 example syntax
From: Sachin Kamat <sachin.kamat@samsung.com>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 6:51 AM, Andreas Färber <afaerber@suse.de> wrote:
> It's <1>, not 1.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index 55ab4f4..99a0c52 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -96,7 +96,7 @@ Example:
>
>                 s2m_osc: clocks {
>                         compatible = "samsung,s2mps11-clk";
> -                       #clock-cells = 1;
> +                       #clock-cells = <1>;
>                         clock-output-names = "xx", "yy", "zz";
>                 };
>
> --
> 1.9.3
>

Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>
