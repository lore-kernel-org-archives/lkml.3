Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3CMJbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:31:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40598 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3CMJbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:31:33 -0400
Date: Wed, 13 Mar 2013 05:31:45 -0400 (EDT)
Message-Id: <20130313.053145.2200448840921851390.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org, gustavo@padovan.org,
        johan.hedberg@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: use PTR_RET instead of IS_ERR + PTR_ERR
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363111995-26866-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363111995-26866-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 13 Mar 2013 02:31:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Tue, 12 Mar 2013 20:13:15 +0200

> @@ -590,10 +590,7 @@ int __init bt_sysfs_init(void)
>  	bt_debugfs = debugfs_create_dir("bluetooth", NULL);
>  
>  	bt_class = class_create(THIS_MODULE, "bluetooth");
> -	if (IS_ERR(bt_class))
> -		return PTR_ERR(bt_class);
> -
> -	return 0;
> +	return PTR_RET(bt_class)

Don't bother submitting patches you aren't even going to try
to compile.

I'm rejecting all of your current submissions.  Resubmit them
when you feel like typing 'make' from time to time.


