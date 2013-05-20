Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3ETHM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:12:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54534 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3ETHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:12:53 -0400
Date: Mon, 20 May 2013 00:12:52 -0700 (PDT)
Message-Id: <20130520.001252.838327096610376306.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1305201008190.4719@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305200941260.4719@fry.nucleusys.com>
	<20130520.000046.631828458050532836.davem@davemloft.net>
	<alpine.DEB.2.02.1305201008190.4719@fry.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 00:12:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Mon, 20 May 2013 10:09:00 +0300 (EEST)

> What about the .c/.h split?

I have no strong opinion either way.
