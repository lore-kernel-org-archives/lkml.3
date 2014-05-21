Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaEUVsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:48:31 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47137 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaEUVs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:48:29 -0400
Message-ID: <537D1F2F.6050100@cogentembedded.com>
Date: Thu, 22 May 2014 01:48:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
CC: davem@davemloft.net, Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH RESEND net-next 1/9] Documentation: devicetree: add old
 and deprecated 'fixed-link'
References: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com> <1400708331-18088-2-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1400708331-18088-2-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/22/2014 01:38 AM, Florian Fainelli wrote:

> Update the fixed-link Device Tree binding documentation to contain
> information about the old and deprecated 5-digit 'fixed-link' property.

> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   Documentation/devicetree/bindings/net/fixed-link.txt | 12 ++++++++++++
>   1 file changed, 12 insertions(+)

> diff --git a/Documentation/devicetree/bindings/net/fixed-link.txt b/Documentation/devicetree/bindings/net/fixed-link.txt
> index e956de1be935..34a991eb213f 100644
> --- a/Documentation/devicetree/bindings/net/fixed-link.txt
> +++ b/Documentation/devicetree/bindings/net/fixed-link.txt
> @@ -18,6 +18,18 @@ properties:
>   * 'asym-pause' (boolean, optional), to indicate that asym_pause should
>     be enabled.
>
> +Old, deprecated 'fixed-link' binding:
> +
> +* A 'fixed-link' property in the EThernet MAC node, with 5 cells, of the

    s/EThernet/Ethernet/

> +  form <a b c d e> with the following accepted values:
> +  - a: emulated phy id, choose any but but unique to the all specified

    s/phy id/PHY ID/

> +    fixed-links, from 0 to 31
> +  - b: duplex configuration: 0 for half duplex, 1 for full duplex
> +  - c: link speed in Mbits/sec, accepted values are: 10, 100 and 1000
> +  - d: pause configuration: 0 for no pause, 1 for pause
> +  - e: asymetric pause configuration: 0 for no asymetric pause, 1 for asymetric

    Asymmetric.

WBR, Sergei

