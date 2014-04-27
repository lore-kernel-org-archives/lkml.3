Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaD0Xyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 19:54:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaD0XyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 19:54:25 -0400
Date: Sun, 27 Apr 2014 19:54:23 -0400 (EDT)
Message-Id: <20140427.195423.788429574120983614.davem@davemloft.net>
To: heiko@sntech.de
Cc: Alexey.Brodkin@synopsys.com, netdev@vger.kernel.org, max.schwarz@online.de,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH v2 2/2] arc_emac: add clock handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <5262035.54Ti8h2BVg@phil>
References: <1712306.TSJMmGq3uZ@phil>
	<5262035.54Ti8h2BVg@phil>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 27 Apr 2014 16:54:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stübner <heiko@sntech.de>
Date: Fri, 25 Apr 2014 10:06:13 +0200

> This adds ability for the arc_emac to really handle its supplying clock.
> To get the needed clock-frequency either a real clock or the previous
> clock-frequency property must be provided.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Tested-by: Max Schwarz <max.schwarz@online.de>

Applied.
