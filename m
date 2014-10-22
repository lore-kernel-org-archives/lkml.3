Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaJVTeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:34:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaJVTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:34:11 -0400
Date: Wed, 22 Oct 2014 15:33:39 -0400 (EDT)
Message-Id: <20141022.153339.553009019191281217.davem@davemloft.net>
To: christophe.leroy@c-s.fr
Cc: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, germain.montoies@c-s.fr
Subject: Re: [PATCH] net: fs_enet: set back promiscuity mode after restart
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141022070547.83AAB1A5E63@localhost.localdomain>
References: <20141022070547.83AAB1A5E63@localhost.localdomain>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 12:34:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Wed, 22 Oct 2014 09:05:47 +0200 (CEST)

> After interface restart (eg: after link disconnection/reconnection), the bridge
> function doesn't work anymore. This is due to the promiscuous mode being cleared
> by the restart.
> 
> The mac-fcc already includes code to set the promiscuous mode back during the restart.
> This patch adds the same handling to mac-fec and mac-scc.
> 
> Tested with bridge function on MPC885 with FEC.
> 
> Reported-by: Germain Montoies <germain.montoies@c-s.fr>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Applied, thanks.
