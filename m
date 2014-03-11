Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaCKCW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:22:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaCKCW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:22:28 -0400
Date: Mon, 10 Mar 2014 22:22:26 -0400 (EDT)
Message-Id: <20140310.222226.1557956325482157663.davem@davemloft.net>
To: peter.bostrom@netrounds.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: Set correct source MAC address with TX VLAN
 offload enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394464635.27812.7.camel@peter-laptop>
References: <1394464635.27812.7.camel@peter-laptop>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 19:22:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Boström <peter.bostrom@netrounds.com>
Date: Mon, 10 Mar 2014 16:17:15 +0100

> With TX VLAN offload enabled the source MAC address for frames sent using the
> VLAN interface is currently set to the address of the real interface. This is
> wrong since the VLAN interface may be configured with a different address.
> 
> The bug was introduced in commit 2205369a314e12fcec4781cc73ac9c08fc2b47de
> ("vlan: Fix header ops passthru when doing TX VLAN offload.").
> 
> This patch sets the source address before calling the create function of the
> real interface.
> 
> Signed-off-by: Peter Boström <peter.bostrom@netrounds.com>

Good catch.

Applied and queued up for -stable, thanks!
