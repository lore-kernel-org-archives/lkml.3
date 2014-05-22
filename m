Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaEVTuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:50:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42113 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaEVTuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:50:52 -0400
Date: Thu, 22 May 2014 15:50:51 -0400 (EDT)
Message-Id: <20140522.155051.371532707765196359.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mISDN: Use mod_timer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400702928-29110-2-git-send-email-manuel.schoelling@gmx.de>
References: <537CFE29.7050100@cogentembedded.com>
	<1400702928-29110-1-git-send-email-manuel.schoelling@gmx.de>
	<1400702928-29110-2-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:50:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Wed, 21 May 2014 22:08:48 +0200

> The code for resetting the timer can be simplified if mod_timer() is used
> instead of del_timer() followed by add_timer().
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied.
