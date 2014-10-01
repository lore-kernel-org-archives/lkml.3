Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaJAElu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:41:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJAElt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:41:49 -0400
Date: Wed, 01 Oct 2014 00:41:45 -0400 (EDT)
Message-Id: <20141001.004145.666953186448073320.davem@davemloft.net>
To: fabf@skynet.be
Cc: alex.aring@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] ieee802154: add __init to
 lowpan_frags_sysctl_register
From: David Miller <davem@davemloft.net>
In-Reply-To: <1016857334.83918.1412138209231.open-xchange@webmail.nmp.skynet.be>
References: <1412109249-7432-1-git-send-email-fabf@skynet.be>
	<20141001002459.GA1007@omega>
	<1016857334.83918.1412138209231.open-xchange@webmail.nmp.skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 21:41:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 1 Oct 2014 06:36:49 +0200 (CEST)

>     I didn't see _ns_ . I'll send the right fix based on wpan-next.

You'll have to send it to me, because I applied your patch already
to net-next.
