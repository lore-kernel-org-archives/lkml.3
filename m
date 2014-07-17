Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaGQGdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:33:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57788 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGQGds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:33:48 -0400
Date: Wed, 16 Jul 2014 23:33:47 -0700 (PDT)
Message-Id: <20140716.233347.1283806216031286454.davem@davemloft.net>
To: grygorii.strashko@ti.com
Cc: f.fainelli@gmail.com, santosh.shilimkar@ti.com, netdev@vger.kernel.org,
        prabhakar.csengg@gmail.com, nsekhar@ti.com, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, mugunthanvnm@ti.com
Subject: Re: [PATCH v2 0/2] net: davinci_mdio: reuse for keystone2 arch
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405512783-20307-1-git-send-email-grygorii.strashko@ti.com>
References: <1405512783-20307-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 23:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 16 Jul 2014 15:13:01 +0300

> The similar MDIO HW blocks is used by keystone 2 SoCs as
> in Davinci SoCs:
> - one in Gigabit Ethernet (GbE) Switch Subsystem
>   See http://www.ti.com/lit/ug/sprugv9d/sprugv9d.pdf
> - one in 10 Gigabit Ethernet Subsystem
>   See http://www.ti.com/lit/ug/spruhj5/spruhj5.pdf
> 
> Hence, reuse Davinci MDIO driver for Keystone 2 and
> enable TI networking for Keystone 2 devices.
> 
> Also, as part of this series, enable PHY's creation from DT, because
> Keystone 2 supports DT boot mode only.
> 
> Changes in v2:
> - review comments applied. 
>   Keystone 2 compatibility string changed to "ti,keystone_mdio".

Series applied to net-next, thanks.
