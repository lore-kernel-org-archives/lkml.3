Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3ARTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:15:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3ARTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:15:07 -0500
Date: Fri, 18 Jan 2013 14:15:06 -0500 (EST)
Message-Id: <20130118.141506.2118336604190817703.davem@davemloft.net>
To: robherring2@gmail.com
Cc: netdev@vger.kernel.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: calxedaxgmac: throw away overrun frames
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358379397-7152-1-git-send-email-robherring2@gmail.com>
References: <1358379397-7152-1-git-send-email-robherring2@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robherring2@gmail.com>
Date: Wed, 16 Jan 2013 17:36:37 -0600

> From: Rob Herring <rob.herring@calxeda.com>
> 
> The xgmac driver assumes 1 frame per descriptor. If a frame larger than
> the descriptor's buffer size is received, the frame will spill over into
> the next descriptor. So check for received frames that span more than one
> descriptor and discard them. This prevents a crash if we receive erroneous
> large packets.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Applied.
