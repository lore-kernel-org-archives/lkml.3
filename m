Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3EBJR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:17:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51572 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3EBJR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:17:57 -0400
Date: Thu, 02 May 2013 05:17:27 -0400 (EDT)
Message-Id: <20130502.051727.949429506738234701.davem@davemloft.net>
To: bjorn@mork.no
Cc: kaber@trash.net, torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <87d2t9bvj1.fsf@nemi.mork.no>
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	<20130502083619.GA22010@macbook.localnet>
	<87d2t9bvj1.fsf@nemi.mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 02:17:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Thu, 02 May 2013 11:06:42 +0200

> Adding the new netdev features will make it go from 1 to 2:

We already had more than 31 feature bits before Patrick's
changes, and I'm pretty sure this was the case when we added
that ethtool API.
