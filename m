Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaFEHGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:06:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaFEHGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:06:32 -0400
Date: Thu, 05 Jun 2014 00:06:30 -0700 (PDT)
Message-Id: <20140605.000630.1200115376924354358.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dns_resolver: Do not accept domain names longer than
 255 chars
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401554673-16311-1-git-send-email-manuel.schoelling@gmx.de>
References: <1401554673-16311-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Jun 2014 00:06:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Sat, 31 May 2014 18:44:33 +0200

> According to RFC1035 "[...] the total length of a domain name (i.e.,
> label octets and label length octets) is restricted to 255 octets or
> less."
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied to net-next, thanks.
