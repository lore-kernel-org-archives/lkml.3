Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3ETHAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:00:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3ETHAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:00:47 -0400
Date: Mon, 20 May 2013 00:00:46 -0700 (PDT)
Message-Id: <20130520.000046.631828458050532836.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1305200941260.4719@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305191136360.4537@fry.nucleusys.com>
	<20130519190116.GA4019@electric-eye.fr.zoreil.com>
	<alpine.DEB.2.02.1305200941260.4719@fry.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 00:00:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Mon, 20 May 2013 09:58:39 +0300 (EEST)

> So first apply patch #1 and then patch #2.

Then nobody can properly GIT bisect through your patch series.

The tree must work and build properly at each and every step
of your patch series.
