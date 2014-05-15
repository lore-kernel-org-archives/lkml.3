Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaEORnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:43:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34513 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaEORna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:43:30 -0400
Date: Thu, 15 May 2014 13:43:28 -0400 (EDT)
Message-Id: <20140515.134328.221963981846625223.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpU84BD4WjTEW0Yn6-R3ocHh25quAj_F8cmkVK=CRZd9Kg@mail.gmail.com>
References: <20140515164703.73a1cf06@canb.auug.org.au>
	<CAM_iQpU84BD4WjTEW0Yn6-R3ocHh25quAj_F8cmkVK=CRZd9Kg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 May 2014 10:43:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 15 May 2014 10:39:20 -0700

> On Wed, May 14, 2014 at 11:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the net-next tree, today's linux-next build (powerpc
>> allnoconfig) produced this warning:
>>
>>
>> include/net/ip.h:211:5: warning: "CONFIG_SYSCTL" is not defined [-Wundef]
>>  #if CONFIG_SYSCTL
>>      ^
>>
>> Introduced by commit 122ff243f5f1 ("ipv4: make ip_local_reserved_ports
>> per netns").
> 
> 
> Oops, blame my fat fingers... Just s/#if/#ifdef/. ;)

I've just pushed out a fix for this, thanks everyone.
