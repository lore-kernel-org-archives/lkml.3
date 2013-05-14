Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab3ENScf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:32:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43486 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab3ENSce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:32:34 -0400
Date: Tue, 14 May 2013 11:32:33 -0700 (PDT)
Message-Id: <20130514.113233.108654708844467379.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: heiko.carstens@de.ibm.com, geert@linux-m68k.org,
        linux-net-drivers@solarflare.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHv2 net 1/2] sfc: Delete EFX_PAGE_IP_ALIGN, equivalent to
 NET_IP_ALIGN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368482311.3305.48.camel@bwh-desktop.uk.solarflarecom.com>
References: <1368482311.3305.48.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 14 May 2013 11:32:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Mon, 13 May 2013 22:58:31 +0100

> The two architectures that define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> (powerpc and x86) now both define NET_IP_ALIGN as 0, so there is no
> need for this optimisation any more.
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>

Applied.
