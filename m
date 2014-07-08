Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaGHAKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:10:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47747 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:10:00 -0400
Date: Mon, 07 Jul 2014 17:09:59 -0700 (PDT)
Message-Id: <20140707.170959.196790738318422847.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: chessman@tux.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11 v3] tlan: Link handling improvements and Olicom
 fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
References: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 17:10:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 30 Jun 2014 18:38:26 +0200

> This patch series improves link handling in tlan driver, allowing the
> cable to be (un)plugged anytime and NetworkManager to work properly.
> 
> Also there are some bugfixes related to Olicom OC-2326 card.

Series applied to net-next, thanks.
