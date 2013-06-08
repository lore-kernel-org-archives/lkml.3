Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3FHLZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 07:25:09 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:60980 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3FHLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 07:25:07 -0400
Message-ID: <51B31442.5020707@synopsys.com>
Date: Sat, 8 Jun 2013 16:53:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
CC: Joe Perches <joe@perches.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "Mischa Jonker" <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "romieu@fr.zoreil.com" <romieu@fr.zoreil.com>
Subject: Re: [PATCH v2] ethernet/arc/arc_emac - Add new driver
References: <1370617656-18349-1-git-send-email-abrodkin@synopsys.com> <1370628783.2209.123.camel@joe-AO722> <4881796E12491D4BB15146FE0209CE643F5CA32B@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5CA32B@DE02WEMBXB.internal.synopsys.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 04:49 PM, Alexey Brodkin wrote:
>  >> +	if (!priv->phy_node) {
>  >> +		dev_err(&pdev->dev, "failed to retrieve phy description "
>  >> +			"from device tree\n");
>  >
>  > Coalesce formats please
>
> Could you please clarify how should I format lines in question?
> I'm a bit lost here.

Don't break the string - even if line becomes > 80 chars. This is to help with
grep and such.

-Vineet
