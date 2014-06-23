Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaFWR1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:27:10 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43951 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbaFWR1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:27:06 -0400
MIME-Version: 1.0
In-Reply-To: <1403486483-4063-4-git-send-email-afaerber@suse.de>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
	<1403486483-4063-4-git-send-email-afaerber@suse.de>
Date: Mon, 23 Jun 2014 10:27:04 -0700
X-Google-Sender-Auth: vzBWYl5q58VXQ8688XJrDkUMR6I
Message-ID: <CAD=FV=UUGQ_ULm+juj0hMxCKhhcXTa2aJT50Y=WrePy9g8u-zA@mail.gmail.com>
Subject: Re: [PATCH 3/4] Documentation: devicetree: Fix tps65090 typos
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Sun, Jun 22, 2014 at 6:21 PM, Andreas Färber <afaerber@suse.de> wrote:
> It's vsys-l{1,2}-supply, not vsys_l{1,2}-supply.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  Documentation/devicetree/bindings/regulator/tps65090.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
> index 34098023..ca69f5e 100644
> --- a/Documentation/devicetree/bindings/regulator/tps65090.txt
> +++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
> @@ -45,8 +45,8 @@ Example:
>                 infet5-supply = <&some_reg>;
>                 infet6-supply = <&some_reg>;
>                 infet7-supply = <&some_reg>;
> -               vsys_l1-supply = <&some_reg>;
> -               vsys_l2-supply = <&some_reg>;
> +               vsys-l1-supply = <&some_reg>;
> +               vsys-l2-supply = <&some_reg>;

Your change matches the code and all existing device trees in the
Linux kernel.  I also see plenty of other bindings with dashes, so
this seems reasonable.

Reviewed-by: Doug Anderson <dianders@chromium.org>
