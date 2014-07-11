Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaGKFFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 01:05:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37289 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaGKFFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 01:05:22 -0400
Message-ID: <53BF7089.3050502@ti.com>
Date: Fri, 11 Jul 2014 10:35:13 +0530
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
Subject: Re: [PATCH 2/2] net: davinci_mdio: allow to create phys from dt
References: <1404911451-9921-1-git-send-email-grygorii.strashko@ti.com> <1404911451-9921-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1404911451-9921-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 06:40 PM, Grygorii Strashko wrote:
> This patch allows to create PHYs from DT in case
> if they are explicitly defined. The of_mdiobus_register() is
> used for such purposes.
>
> For backward compatibility, call  of_mdiobus_register() only in case
> if at least one PHY's child is defined in DT, otherwise rollback to
> mdiobus_register().
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Except Santhosh comment patch looks good to me.

Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
