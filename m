Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaI2ShM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:37:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60252 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaI2ShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:37:11 -0400
Date: Mon, 29 Sep 2014 14:37:05 -0400 (EDT)
Message-Id: <20140929.143705.1969808728959274484.davem@davemloft.net>
To: m.grzeschik@pengutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 0/5] ARCNET: add support for EAE multi interfac card
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411984538-953-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1411984538-953-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 11:37:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Mon, 29 Sep 2014 11:55:33 +0200

> this series adds support for the PLX Bridge based multi interface
> pci cards and adds support to change device address on com200xx chips
> during runtime.
> 
> This series is based on v3.17-rc7.
> It is fixed for build against com20020_cs.

Series applied, let's see how to compile goes this time.
