Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3C1DZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 23:25:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35711 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3C1DZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 23:25:05 -0400
Date: Wed, 27 Mar 2013 23:25:03 -0400 (EDT)
Message-Id: <20130327.232503.1189281657154200341.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: paul.gortmaker@windriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tokenring: delete last holdout of CONFIG_TR
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364417548.1345.38.camel@x61.thuisdomein>
References: <1364417548.1345.38.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 27 Mar 2013 20:25:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Wed, 27 Mar 2013 21:52:28 +0100

> Tokenring support was deleted in v3.5. One last holdout of the macro
> CONFIG_TR escaped that fate. Until now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to net-next, thanks.
