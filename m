Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3J2Vtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:49:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49071 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3J2Vti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:49:38 -0400
Date: Tue, 29 Oct 2013 17:49:36 -0400 (EDT)
Message-Id: <20131029.174936.13317032766742363.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net 2/3] r8152: modify the tx flow
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383033377-1178-3-git-send-email-hayeswang@realtek.com>
References: <1383033377-1178-1-git-send-email-hayeswang@realtek.com>
	<1383033377-1178-3-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 14:49:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 29 Oct 2013 15:56:16 +0800

> Support stopping and waking tx queue. The maximum tx queue length
> is 60.

What is so special about the number 60?  It seems arbitrary, and if
it isn't arbitrary you haven't described why this value was choosen.

I've asked you politely last time around to significantly improve
the quality of your commit messages, and you haven't done this at
all.

I'm not applying any of these patches until your commit messages
properly describe your changes completely.
