Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3FLHVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:21:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50970 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3FLHVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:21:04 -0400
Date: Wed, 12 Jun 2013 00:21:03 -0700 (PDT)
Message-Id: <20130612.002103.916991474696226731.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130611.222706.1492583255605214982.davem@davemloft.net>
References: <20130606190929.GB18827@tuxdriver.com>
	<20130611.222706.1492583255605214982.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John, I also don't like the ATK9K Kconfig option name change added in
this pull request, this is exactly the kind of thing that drives
Linus insane.

Change the default, fine, but changing the name is unnecssary churn
and adds a new config prompt that people are going to respond to
incorrectly when they type "make oldconfig"

