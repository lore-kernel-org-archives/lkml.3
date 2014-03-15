Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaCOCVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 22:21:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41326 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaCOCVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 22:21:35 -0400
Date: Fri, 14 Mar 2014 22:21:33 -0400 (EDT)
Message-Id: <20140314.222133.1978976674383447094.davem@davemloft.net>
To: vfalico@redhat.com
Cc: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net,
        stefanr@s5r6.in-berlin.de, sw@simonwunderlich.de,
        Neil.Jerram@metaswitch.com, horms@verge.net.au, Arvid.Brodin@xdin.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] bonding: use correct ether type for alb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394710918-29540-1-git-send-email-vfalico@redhat.com>
References: <1394710918-29540-1-git-send-email-vfalico@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Mar 2014 19:21:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Veaceslav Falico <vfalico@redhat.com>
Date: Thu, 13 Mar 2014 12:41:56 +0100

> There have been reports that, while using the ETH_P_LOOP ether type
> (0x0060), the ether type is treated as its packet length.
> 
> To avoid that and to not break already existing apps - add new ether type
> ETH_P_LOOPBACK that contains the correct id - 0x9000.

Series applied, thanks Veaceslav.
