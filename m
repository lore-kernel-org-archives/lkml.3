Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3HVIXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:23:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3HVIXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:23:51 -0400
Date: Thu, 22 Aug 2013 01:23:48 -0700 (PDT)
Message-Id: <20130822.012348.1370012681436362922.davem@davemloft.net>
To: brouer@redhat.com
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ADSL/ATM linklayer tc shaping regression fix commits for stable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130822100426.39be319d@redhat.com>
References: <20130821140350.2b953007@redhat.com>
	<20130821.112023.744177612387539958.davem@davemloft.net>
	<20130822100426.39be319d@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 22 Aug 2013 01:23:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 22 Aug 2013 10:04:26 +0200

> So, for future reference:
> 
> Stable patches for the networking tree, I should:
> 1) check http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
>    to see if my patch is already on your stable queue
> 2) if not, ask you and cc netdev@vger.kernel.org
> 3) you will handle the interaction with Greg and stable@vger.kernel.org
> 
> Correct?

Yes, and that's how it's been with the networking for years.

