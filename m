Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3FLJYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:24:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3FLJX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:23:56 -0400
Date: Wed, 12 Jun 2013 02:23:45 -0700 (PDT)
Message-Id: <20130612.022345.638990137181901830.davem@davemloft.net>
To: tushar.behera@linaro.org
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org, mkl@pengutronix.de,
        wg@grandegger.com
Subject: Re: [PATCH 09/15] net: can: Convert to use devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370864113-17895-10-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-10-git-send-email-tushar.behera@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.behera@linaro.org>
Date: Mon, 10 Jun 2013 17:05:07 +0530

> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Applied.
