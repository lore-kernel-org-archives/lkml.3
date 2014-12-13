Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaLMPp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 10:45:58 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55479 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaLMPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 10:45:57 -0500
Message-ID: <548C5F1F.8070804@roeck-us.net>
Date: Sat, 13 Dec 2014 07:45:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, wim@iguana.be,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, greta.zhang@mediatek.com,
        eddie.huang@mediatek.com
Subject: Re: [PATCH v2 2/2] ARM: mediatek: dts: Add bindings for watchdog
References: <1418395859-32209-1-git-send-email-matthias.bgg@gmail.com> <1418395859-32209-3-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1418395859-32209-3-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.548C5F35.0032,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 24
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 06:50 AM, Matthias Brugger wrote:
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>   Documentation/devicetree/bindings/watchdog/mtk-wdt.txt | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
>
> diff --git a/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
> new file mode 100644
> index 0000000..af9eb5b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
> @@ -0,0 +1,13 @@
> +Mediatek SoCs Watchdog timer
> +
> +Required properties:
> +
> +- compatible : should be "mediatek,mt6589-wdt"

"mediatek" is undefined as vendor prefix in the current upstream code.
Is this vendor prefix coming in from another patch set ?

Guenter

> +- reg : Specifies base physical address and size of the registers.
> +
> +Example:
> +
> +wdt: watchdog@010000000 {
> +	compatible = "mediatek,mt6589-wdt";
> +	reg = <0x10000000 0x18>;
> +};
>

