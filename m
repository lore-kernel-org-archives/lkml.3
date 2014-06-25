Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaFYTye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:54:34 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:55493 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFYTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:54:32 -0400
MIME-Version: 1.0
In-Reply-To: <1403723019-6212-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
	<1403723019-6212-5-git-send-email-javier.martinez@collabora.co.uk>
Date: Wed, 25 Jun 2014 12:54:31 -0700
X-Google-Sender-Auth: r3zDSFyp8M-F574VKH_u60DbpjI
Message-ID: <CAD=FV=Udt1G4MwSOAS-KmJa=zm4OBkPPxFO81ezY+ywG6zKRgw@mail.gmail.com>
Subject: Re: [PATCH v4 04/14] clk: max77686: Improve Maxim 77686 PMIC clocks binding
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Wed, Jun 25, 2014 at 12:03 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Like most clock drivers, the Maxim 77686 PMIC clock binding
> follows the convention that the "#clock-cells" property is
> used to specify the number of cells in a clock provider.
>
> But the binding document is not clear enough that it shall
> be set to 1 since the PMIC support multiple clocks outputs.
>
> Also, explain that the clocks identifiers are defined in a
> header file that can be included by Device Tree source with
> client nodes to avoid using magic numbers.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>
> Changes since v3:
>  - Don't change clock-names property to make clear that it's
>    the consumer clock name and should not match the producer clock.
>    Suggested by Doug Anderson.
>
>  Documentation/devicetree/bindings/clock/maxim,max77686.txt | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
