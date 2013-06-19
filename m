Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641Ab3FSJO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:14:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410Ab3FSJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:14:51 -0400
Date: Wed, 19 Jun 2013 02:14:50 -0700 (PDT)
Message-Id: <20130619.021450.1126981647735749233.davem@davemloft.net>
To: tushar.behera@linaro.org
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        sachin.kamat@linaro.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH V2 1/15] sparc,leon: Convert to use
 devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371460064-19549-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-2-git-send-email-tushar.behera@linaro.org>
	<1371460064-19549-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.behera@linaro.org>
Date: Mon, 17 Jun 2013 14:37:44 +0530

> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> While at it, also remove the error message as devm_ioremap_resource()
> also prints similar error message.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Applied.
