Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab3GWQBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:01:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33449 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:01:40 -0400
Message-ID: <51EEA8E2.6020003@nvidia.com>
Date: Tue, 23 Jul 2013 09:01:38 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        xulinuxkernel <xulinuxkernel@gmail.com>
Subject: Re: [PATCH] pinctrl: fix a memleak when freeing maps
References: <1374536739-18966-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1374536739-18966-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 04:45 PM, Linus Walleij wrote:
> We forgot to free the node itself when free:ing a map.
> 
> Reported-by: xulinuxkernel <xulinuxkernel@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Stephen Warren <swarren@nvidia.com>

The full name in the reported-by doesn't look accurate, but I suppose
that isn't an s-o-b entry, so it's not a big deal.
