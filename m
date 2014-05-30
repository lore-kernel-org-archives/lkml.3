Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbaE3XbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:31:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934923AbaE3XbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:31:09 -0400
Date: Fri, 30 May 2014 16:31:07 -0700 (PDT)
Message-Id: <20140530.163107.599356297485033501.davem@davemloft.net>
To: ivan@ru.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, alistair@popple.id.au, robh+dt@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 2/2] emac: aggregation of v1-2 PLB errors for IER
 register
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401129279.24099.23.camel@localhost.localdomain>
References: <1401129279.24099.23.camel@localhost.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 16:31:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Mikhaylov <ivan@ru.ibm.com>
Date: Mon, 26 May 2014 22:34:39 +0400

> Aggreagation of version 1-2 because of version 1 can hit
> PLB errors too. If it's not set so we missing events for PLB bits
> and driver can't process those interrupts.
> 
> Signed-off-by: Ivan Mikhaylov <ivan@ru.ibm.com>

Applied.
