Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaGIXwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:52:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34667 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaGIXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:52:34 -0400
Date: Wed, 09 Jul 2014 16:52:32 -0700 (PDT)
Message-Id: <20140709.165232.539576872991411664.davem@davemloft.net>
To: grygorii.strashko@ti.com
Cc: f.fainelli@gmail.com, santosh.shilimkar@ti.com, netdev@vger.kernel.org,
        prabhakar.csengg@gmail.com, nsekhar@ti.com, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 1/2] net: davinci_mdio: reuse for keystone2 arch
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>
References: <1404911451-9921-1-git-send-email-grygorii.strashko@ti.com>
	<1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 09 Jul 2014 16:52:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 9 Jul 2014 16:10:50 +0300

>  Required properties:
> -- compatible		: Should be "ti,davinci_mdio"
> +- compatible		: Should be "ti,davinci_mdio" or "ti,keystone-mdio"

Why the inconsistency in naming schemes?  I don't see any reason
to be different wrt. "_" vs. "-" in the name string.
