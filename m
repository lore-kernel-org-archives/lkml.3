Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3ETHn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:43:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54902 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3ETHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:43:26 -0400
Date: Mon, 20 May 2013 00:43:24 -0700 (PDT)
Message-Id: <20130520.004324.1700573748194578434.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1305201014220.4719@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305201008190.4719@fry.nucleusys.com>
	<20130520.001252.838327096610376306.davem@davemloft.net>
	<alpine.DEB.2.02.1305201014220.4719@fry.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 00:43:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Mon, 20 May 2013 10:18:17 +0300 (EEST)

> On Mon, 20 May 2013, David Miller wrote:
> 
>> From: Petko Manolov <petkan@nucleusys.com>
>> Date: Mon, 20 May 2013 10:09:00 +0300 (EEST)
>> 
>> > What about the .c/.h split?
>> 
>> I have no strong opinion either way.
> 
> OK, so i'll prepare new patch series that coalesce my original patch #1 
> and #2, and apply the Francois suggestion about using the generic 
> netdev_alloc_skb_ip_align() in the interrupt path.
> 
> Which tree would you want me to diff against?

As has been explained to you already, cleanups belong in 'net-next',
bug fixes belong in 'net'.

If you series has both, you have to submit them separately.  Submit
the bug fixes to 'net', then the next time I merge 'net' into 'net-next'
you can submit the cleanups on top against 'net-next'.
