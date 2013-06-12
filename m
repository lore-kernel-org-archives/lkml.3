Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3FLJX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:23:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52135 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3FLJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:23:27 -0400
Date: Wed, 12 Jun 2013 02:23:25 -0700 (PDT)
Message-Id: <20130612.022325.1006874954155178574.davem@davemloft.net>
To: tushar.behera@linaro.org
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 06/15] net: bcm63xx_enet: Convert to use
 devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370864113-17895-7-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-7-git-send-email-tushar.behera@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.behera@linaro.org>
Date: Mon, 10 Jun 2013 17:05:04 +0530

> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

In net-next, the driver is already using devm_ioremap_resource().
