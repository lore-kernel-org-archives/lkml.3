Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaEBURv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:17:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37107 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaEBURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:17:50 -0400
Date: Fri, 02 May 2014 16:17:47 -0400 (EDT)
Message-Id: <20140502.161747.121619975003852704.davem@davemloft.net>
To: grygorii.strashko@ti.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, rdunlap@infradead.org,
        jic23@kernel.org, santosh.shilimkar@ti.com, nsekhar@ti.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sergei.shtylyov@cogentembedded.com, prabhakar.csengg@gmail.com
Subject: Re: [PATCH v3 0/4] introduce devm_mdiobus_alloc/free and clean up
 davinci mdio
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
References: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 May 2014 13:17:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 30 Apr 2014 15:23:32 +0300

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

Series applied to net-next, thanks.
