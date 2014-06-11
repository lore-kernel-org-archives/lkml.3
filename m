Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaFKWkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:40:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47736 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaFKWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:40:38 -0400
Date: Wed, 11 Jun 2014 15:40:38 -0700 (PDT)
Message-Id: <20140611.154038.2217975059059399377.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, varkab@cdac.in
Subject: Re: [net-next PATCH] mrf24j40: add device managed APIs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402461284-8435-1-git-send-email-varkab@cdac.in>
References: <1402461284-8435-1-git-send-email-varkab@cdac.in>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 15:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>
Date: Wed, 11 Jun 2014 10:04:44 +0530

> adds the device managed APIs so that no need worry about
> freeing the resources.
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

Applied.
