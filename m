Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab3CVOdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:33:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50098 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab3CVOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:33:04 -0400
Date: Fri, 22 Mar 2013 10:33:02 -0400 (EDT)
Message-Id: <20130322.103302.1277256650283142022.davem@davemloft.net>
To: afleming@freescale.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ben.c@servergy.com
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
From: David Miller <davem@davemloft.net>
In-Reply-To: <A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com>
References: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>
	<20130322.101139.1942128058226201237.davem@davemloft.net>
	<A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 07:33:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fleming Andy-AFLEMING <afleming@freescale.com>
Date: Fri, 22 Mar 2013 14:31:50 +0000

> It would appear one of our customers is attempting to upstream our
> code for us. We are aware that this current solution is unacceptable
> (which is why we have not submitted it), and we are currently trying
> to develop a less hacky solution that integrates with qdisc.

Ben, can can you coordinate with people instead of doing crap like
this?
