Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbaD3OZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:25:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55957 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698AbaD3OZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:25:46 -0400
Message-ID: <536107C8.9060002@ti.com>
Date: Wed, 30 Apr 2014 10:25:12 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Sekhar Nori <nsekhar@ti.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sergei.shtylyov@cogentembedded.com>, <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v3 0/4] introduce devm_mdiobus_alloc/free and clean up
 davinci mdio
References: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2014 08:23 AM, Grygorii Strashko wrote:
> Introduce a resource managed devm_mdiobus_alloc[_size]()/devm_mdiobus_free()
> to automatically clean up MDIO bus alocations made by MDIO drivers,
> thus leading to simplified MDIO drivers code.
> 
> Clean up Davinci MDIO driver and use new devm API.
> 
> Changes in v3:
> - added devm_mdiobus_alloc_size() and
>   devm_mdiobus_alloc() converted to be just a simple wrapper now.
> 
> Changes in v2:
> - minor comments taken into account
> - additional patches added for cleaning up Davinci MDIO driver
> 
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> 
> Grygorii Strashko (4):
>   mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
>   net: davinci_mdio: use devm_* api
>   net: davinci_mdio: drop pinctrl_pm_select_default_state from probe
>   net: davinci_mdio: simplify IO memory mapping
> 
Thanks for the updates. The series looks good to me.
Feel free to my ack if you need one...
Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>

