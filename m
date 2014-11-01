Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbaKAIp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 04:45:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35978 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaKAIpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 04:45:54 -0400
Message-ID: <54549DBA.5020102@collabora.co.uk>
Date: Sat, 01 Nov 2014 09:45:46 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>
CC: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        carlos@github.map.fastly.net, rdunlap@infradead.org, jkosina@suse.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: Document binding for regulator suspend
 voltage
References: <1414813978-32233-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1414813978-32233-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 11/01/2014 04:52 AM, Doug Anderson wrote:
> This patch builds upon (291d761 regulator: Document binding for
> regulator suspend state for PM state) to allow setting the uV in
> addition to the state at suspend time.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  Documentation/devicetree/bindings/regulator/regulator.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
> index aaad615..4e7ed76 100644
> --- a/Documentation/devicetree/bindings/regulator/regulator.txt
> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
> @@ -28,6 +28,8 @@ Optional properties:
>  - regulator-state-[mem/disk] node has following common properties:
>  	- regulator-on-in-suspend: regulator should be on in suspend state.
>  	- regulator-off-in-suspend: regulator should be off in suspend state.
> +	- regulator-suspend-microvolt: regulator should be set to this voltage
> +	  in suspend.

The patch looks good to me:

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

On thing I wonder is if the binding should say that the suspend voltage is
independent of the runtime one and it may be outside of the runtime range?

Best regards,
Javier
