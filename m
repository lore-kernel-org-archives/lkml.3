Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaCJRk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:40:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44897 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaCJRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:40:58 -0400
Date: Mon, 10 Mar 2014 13:40:54 -0400 (EDT)
Message-Id: <20140310.134054.2195508036199798660.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, jbenc@redhat.com, edumazet@google.com,
        dborkman@redhat.com, horms@verge.net.au, Paul.Durrant@citrix.com,
        tgraf@suug.ch, herbert@gondor.apana.org.au, mszeredi@suse.cz,
        panweiping3@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] skbuff: skb_segment: s/fskb/list_skb/
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394468807-25980-5-git-send-email-mst@redhat.com>
References: <1394468807-25980-1-git-send-email-mst@redhat.com>
	<1394468807-25980-5-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 10:40:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a netdev reader, I don't see patches 1-3, did you post them somewhere else
and not CC: netdev?

If so, please don't do that without at least making a mention of what's going
on in the 0/N posting.
