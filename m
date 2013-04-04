Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195Ab3DDPi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:38:27 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:37552 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129Ab3DDPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:38:25 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QOb9J0FJuBLqIwprdItw==
X-RZG-CLASS-ID: mo05
Message-ID: <515D9E4C.6000409@denx.de>
Date: Thu, 04 Apr 2013 17:37:48 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-doc@vger.kernel.org, Alejandro Mery <amery@geeks.cl>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com
Subject: Re: [PATCH 1/5] net: Add EMAC ethernet driver found on Allwinner
 A10 SoC's
References: <1364077814-2233-1-git-send-email-maxime.ripard@free-electrons.com> <1364077814-2233-2-git-send-email-maxime.ripard@free-electrons.com> <201303242003.52827.florian@openwrt.org>
In-Reply-To: <201303242003.52827.florian@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On 24.03.2013 20:03, Florian Fainelli wrote:
> Your phylib implementation looks good now, just some minor comments below:

Thanks for the review. I'll try to address your new comments in a few
days (currently swamped).

Thanks,
Stefan

