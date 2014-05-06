Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbaEFDEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:04:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35862 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:04:28 -0400
Date: Mon, 05 May 2014 23:04:27 -0400 (EDT)
Message-Id: <20140505.230427.1025985660046509545.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 07/24] net, diet: Make ping sockets optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-8-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-8-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:04:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:25:56 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> This saves about 6k text/data. ping still works fine using raw
> sockets like it always did.
> 
>    text	   data	    bss	    dec	    hex	filename
>  268128	  11555	   7872	 287555	  46343	net/ipv4/built-in.o-noping
>  273610	  11843	   8176	 293629	  47afd	net/ipv4/built-in.o-ping
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Sorry, not applying this, it's been discussed already, and it's
exactly small'ish systems that want this facility.

We want to move away from raw sockets, and making this optional
is not going to help us move forward down that path.
