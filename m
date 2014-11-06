Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaKFRcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:32:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaKFRcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:32:01 -0500
Message-ID: <545BB08E.8070607@suse.de>
Date: Thu, 06 Nov 2014 18:31:58 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Jiri Kosina <trivial@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] documentation: pinctrl bindings: Fix trivial typo 'abitrary'
References: <1415288331-785-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1415288331-785-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2014 um 16:38 schrieb Soren Brinkmann:
> A misspelled 'arbitrary' propagated to quite a few locations in the DT
> binding documentation for pin-controllers. Fixing by:
>   git grep abitrary | cut -f1 -d: | xargs sed -i 's/abitrary/arbitrary/'
> 
> Reported-by: Andreas Färber <afaerber@suse.de>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt | 2 +-
>  Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt     | 2 +-
>  Documentation/devicetree/bindings/pinctrl/lantiq,falcon-pinumx.txt   | 2 +-
>  Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt     | 2 +-
>  Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt  | 2 +-
>  Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt           | 2 +-
>  Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt          | 2 +-
>  Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt   | 2 +-
>  Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt   | 2 +-
>  Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt   | 2 +-
>  Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt   | 2 +-
>  Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt   | 2 +-
>  12 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Andreas Färber <afaerber@suse.de>

Thanks,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
