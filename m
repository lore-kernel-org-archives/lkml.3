Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaGKFED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 01:04:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36459 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaGKFEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 01:04:00 -0400
Message-ID: <53BF7037.3000800@ti.com>
Date: Fri, 11 Jul 2014 10:33:51 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, <santosh.shilimkar@ti.com>,
        <netdev@vger.kernel.org>
CC: <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 1/2] net: davinci_mdio: reuse for keystone2 arch
References: <1404911451-9921-1-git-send-email-grygorii.strashko@ti.com> <1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 06:40 PM, Grygorii Strashko wrote:
> The similar MDIO HW blocks is used by keystone 2 SoCs as
> in Davinci SoCs:
> - one in Gigabit Ethernet (GbE) Switch Subsystem
>   See http://www.ti.com/lit/ug/sprugv9d/sprugv9d.pdf
> - one in 10 Gigabit Ethernet Subsystem
>   See http://www.ti.com/lit/ug/spruhj5/spruhj5.pdf
>
> Hence, reuse Davinci MDIO driver for Keystone 2 and
> enable TI networking for Keystone 2 devices
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
