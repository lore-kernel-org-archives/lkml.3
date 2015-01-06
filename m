Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbbAFWko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:40:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbAFWkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:40:42 -0500
Date: Tue, 06 Jan 2015 17:40:39 -0500 (EST)
Message-Id: <20150106.174039.783537681001060022.davem@davemloft.net>
To: ani@arista.com
Cc: corbet@lwn.net, edumazet@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, P@draigbrady.com, netdev@vger.kernel.org,
        fruggeri@arista.com
Subject: Re: [PATCH 1/1] update ip-sysctl.txt documentation 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420583625-32414-1-git-send-email-ani@arista.com>
References: <1420583625-32414-1-git-send-email-ani@arista.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 14:40:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ani Sinha <ani@arista.com>
Date: Tue,  6 Jan 2015 14:33:45 -0800

> @@ -64,8 +64,10 @@ fwmark_reflect - BOOLEAN
>  	Default: 0
>  
>  route/max_size - INTEGER
> -	Maximum number of routes allowed in the kernel.  Increase
> -	this when using large numbers of interfaces and/or routes.
> +        Post linux kernel 3.6, this is depricated for ipv4 as route cache is no
> +        longer used. For ipv6, this is used to limit the maximum number of ipv6
> +        routes allowed in the kernel.  Increase this when using large numbers of
> +        interfaces and/or routes.

Please do not change the TABs into sequenes of space characters.
