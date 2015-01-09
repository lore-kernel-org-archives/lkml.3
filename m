Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbbAIEHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:07:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50806 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbbAIEHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:07:12 -0500
Date: Thu, 08 Jan 2015 20:12:56 -0800 (PST)
Message-Id: <20150108.201256.84753051983146804.davem@davemloft.net>
To: h.feurstein@gmail.com
Cc: netdev@vger.kernel.org, fabio.estevam@freescale.com,
        frank.li@freescale.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix NULL pointer dereference in
 fec_enet_timeout_work
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420638497-6871-1-git-send-email-hubert.feurstein@deto.at>
References: <1420638497-6871-1-git-send-email-hubert.feurstein@deto.at>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Jan 2015 20:07:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>
Date: Wed,  7 Jan 2015 14:48:17 +0100

> From: Hubert Feurstein <h.feurstein@gmail.com>
> 
> This patch initialises the fep->netdev pointer. This pointer was not
> initialised at all, but is used in fec_enet_timeout_work and in some
> error paths.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Applied.
