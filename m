Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3C2TaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:30:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56356 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab3C2TaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:30:06 -0400
Date: Fri, 29 Mar 2013 15:30:04 -0400 (EDT)
Message-Id: <20130329.153004.1825925128455079185.davem@davemloft.net>
To: robherring2@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH 2/2] net: calxedaxgmac: Wake-on-LAN fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364506365-13689-2-git-send-email-robherring2@gmail.com>
References: <1364506365-13689-1-git-send-email-robherring2@gmail.com>
	<1364506365-13689-2-git-send-email-robherring2@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Mar 2013 12:30:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robherring2@gmail.com>
Date: Thu, 28 Mar 2013 16:32:45 -0500

> From: Rob Herring <rob.herring@calxeda.com>
> 
> WOL is broken because the magic packet status bit is getting set rather
> than the enable bit. The PMT interrupt is not getting serviced because
> the PMT interrupt is also enabled on the global interrupt, but not
> cleared by the global interrupt and the global interrupt is higher
> priority. This fixes both of these issues to get WOL working.
> 
> There's still a problem with receive after resume, but at least now we
> can wake-up.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Applied.
