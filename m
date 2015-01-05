Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbbAEVdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:33:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbbAEVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:33:14 -0500
Date: Mon, 05 Jan 2015 16:33:11 -0500 (EST)
Message-Id: <20150105.163311.1868277821228057884.davem@davemloft.net>
To: k.kozlowski@samsung.com
Cc: alex.aring@gmail.com, linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at86rf230: Constify struct regmap_config
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420448551-9443-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448551-9443-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Jan 2015 13:33:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Date: Mon, 05 Jan 2015 10:02:31 +0100

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied.
