Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282AbaFTWaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:30:16 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:42343 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030220AbaFTWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:30:13 -0400
Message-ID: <1403303515.589.361.camel@xylophone>
Subject: Re: [Linux-kernel] [PATCH 2/4] drivers/base: devres.c: Add block
 copy func. for managed devices
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, heiko@sntech.de,
        linux-kernel@codethink.co.uk, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        broonie@kernel.org
Date: Fri, 20 Jun 2014 23:31:55 +0100
In-Reply-To: <1403192765-3258-3-git-send-email-rob.jones@codethink.co.uk>
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
	 <1403192765-3258-3-git-send-email-rob.jones@codethink.co.uk>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 16:46 +0100, Rob Jones wrote:
[...]
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -793,7 +793,7 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
>  /**
>   * devm_kstrdup - Allocate resource managed space and
>   *                copy an existing string into that.
> - * @dev: Device to allocate memory for
> + * @dev:Device to allocate memory for

You shouldn't be changing this comment...

Ben.

>   * @s: the string to duplicate
>   * @gfp: the GFP mask used in the devm_kmalloc() call when
>   *       allocating memory
[...]


