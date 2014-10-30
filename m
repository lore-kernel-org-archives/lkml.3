Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767AbaJ3UM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:12:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58871 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ3UMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:12:54 -0400
Date: Thu, 30 Oct 2014 16:12:52 -0400 (EDT)
Message-Id: <20141030.161252.246867972287253209.davem@davemloft.net>
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org, mugunthanvnm@ti.com, netdev@vger.kernel.org
Subject: Re: PATCH: Add IFF_ALLMULTI support to cpsw (and fix IFF_PROMISC
 support too)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141029190612.GH24110@csclub.uwaterloo.ca>
References: <20141029190612.GH24110@csclub.uwaterloo.ca>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 13:12:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 29 Oct 2014 15:06:12 -0400

> The cpsw driver did not support the IFF_ALLMULTI flag which makes dynamic
> multicast routing rather hard to handle.  Related to this, when enabling
> IFF_PROMISC in non dual_emac mode, all registered vlans are flushed,
> and only broadcast and unicast are allowed which isn't what you would
> want from IFF_PROMISC.
> 
> A new cpsw_ale_set_allmulti function now scans through the ALE entry
> table and adds or removes the host port from the unregistered multicast
> port mask depending on the state of IFF_ALLMULTI.  In promisc mode,
> it is also called to enable reception of all multicast traffic.
> 
> With this change I am now able to run dynamic multicast routing and also
> use tcpdump and actually see multicast traffic.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

Please fix your Subject line and resubmit this patch.

Subject lines end up as the commit message header text, and
therefore must be of the form:

subsystem: Description.

In this case "cpsw: " is probably an appropriate subsystem
prefix.
