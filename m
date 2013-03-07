Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3CGAfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:35:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33435 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3CGAfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:35:15 -0500
Date: Wed, 06 Mar 2013 19:35:11 -0500 (EST)
Message-Id: <20130306.193511.1262845535253279851.davem@davemloft.net>
To: joe@perches.com
Cc: silviupopescu1990@gmail.com, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CAIF: fix indentation for function arguments
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362614837.2093.30.camel@joe-AO722>
References: <1362606521-16848-1-git-send-email-silviupopescu1990@gmail.com>
	<1362614837.2093.30.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 06 Mar 2013 16:35:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 06 Mar 2013 16:07:17 -0800

> On Wed, 2013-03-06 at 23:48 +0200, Silviu-Mihai Popescu wrote:
>> This lines up function arguments on second and subsequent lines at the
>> first column after the openning parenthesis of the first line.
> []
>> diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
> []
>> @@ -301,10 +301,10 @@ static void dev_flowctrl(struct net_device *dev, int on)
>>  }
>>  
>>  void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
>> -			struct cflayer *link_support, int head_room,
>> -			struct cflayer **layer, int (**rcv_func)(
>> -				struct sk_buff *, struct net_device *,
>> -				struct packet_type *, struct net_device *))
>> +		     struct cflayer *link_support, int head_room,
>> +		     struct cflayer **layer, int (**rcv_func)(
>> +		     struct sk_buff *, struct net_device *,
>> +		     struct packet_type *, struct net_device *))
> 
> This makes it seem that caif_enroll_dev takes more args.
> 
> I think this style is better (aligned to appropriate open paren)
> 
> void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
> 		     struct cflayer *link_support, int head_room,
> 		     struct cflayer **layer,
> 		     int (**rcv_func)(struct sk_buff *, struct net_device *,
> 				      struct packet_type *, struct net_device *))

Agreed.
