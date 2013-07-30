Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab3G3XYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:24:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43345 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3G3XYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:24:35 -0400
Date: Tue, 30 Jul 2013 16:24:34 -0700 (PDT)
Message-Id: <20130730.162434.539163047913568607.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, florian@openwrt.org
Subject: Re: [PATCH v2] net: Add MOXA ART SoCs ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374842890-20735-1-git-send-email-jonas.jensen@gmail.com>
References: <1374140806-12485-1-git-send-email-jonas.jensen@gmail.com>
	<1374842890-20735-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 16:24:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Fri, 26 Jul 2013 14:48:10 +0200

> +
> +CFLAGS_moxart_ether.o := -DDEBUG

This is not appropriate, please remove this.
