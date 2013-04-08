Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017Ab3DHQbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:31:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51728 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762805Ab3DHQbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:31:48 -0400
Message-ID: <1365438708.2029.2.camel@joe-AO722>
Subject: Re: [PATCH] [trivial]treewide: Fix typo in printks and comments
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 09:31:48 -0700
In-Reply-To: <1365437356-24720-1-git-send-email-standby24x7@gmail.com>
References: <1365437356-24720-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 01:09 +0900, Masanari Iida wrote:
> Correct spelling typos in printk and comments

Found with a tool?

> diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
[]
> @@ -1314,13 +1314,13 @@ static irqreturn_t gsc_irq_handler(int irq, void *dev_id)
[]
> -		dev_err(ippdrv->dev, "occured overflow at %d, status 0x%x.\n",
> +		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",

The uses of "occurred" could be omitted just as well too.

> -		dev_dbg(ippdrv->dev, "occured frame done at %d, status 0x%x.\n",
> +		dev_dbg(ippdrv->dev, "occurred frame done at %d, status 0x%x.\n",


