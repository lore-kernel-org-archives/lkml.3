Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3HMWyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:54:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45132 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab3HMWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:54:44 -0400
Date: Tue, 13 Aug 2013 15:54:43 -0700 (PDT)
Message-Id: <20130813.155443.1789890841731289313.davem@davemloft.net>
To: vyasevic@redhat.com
Cc: ast@fiberby.net, stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr()
 with ifinfomsg header
From: David Miller <davem@davemloft.net>
In-Reply-To: <52093E29.5010604@redhat.com>
References: <52090C26.4090001@fiberby.net>
	<1376325009-8399-1-git-send-email-ast@fiberby.net>
	<52093E29.5010604@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 13 Aug 2013 15:54:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevic@redhat.com>
Date: Mon, 12 Aug 2013 15:57:29 -0400

> On 08/12/2013 12:30 PM, Asbjoern Sloth Toennesen wrote:
>> Fix the iproute2 command `bridge vlan show`, after switching from
>> rtgenmsg to ifinfomsg.
>>
>> Signed-off-by: Asbjoern Sloth Toennesen <ast@fiberby.net>
> 
> 
> Thanks..  I've still been using an older iproute version and didn't
> see this.
> 
> 
> Reviewed-by: Vlad Yasevich <vyasevich@gmail.com>

What introduced this regression?
