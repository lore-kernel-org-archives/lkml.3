Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaKWSqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:46:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34630 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaKWSq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:46:28 -0500
Date: Sun, 23 Nov 2014 13:46:23 -0500 (EST)
Message-Id: <20141123.134623.2061031332250984539.davem@davemloft.net>
To: pieter@boesman.nl
Cc: josh@joshtriplett.org, alexander.h.duyck@intel.com,
        viro@zeniv.linux.org.uk, ast@plumgrid.com, akpm@linux-foundation.org,
        beber@meleeweb.net, catalina.mocanu@gmail.com, dborkman@redhat.com,
        edumazet@google.com, ebiederm@xmission.com, fabf@skynet.be,
        fuse-devel@lists.sourceforge.net, geert@linux-m68k.org,
        hughd@google.com, iulia.manda21@gmail.com, JBeulich@suse.com,
        bfields@fieldses.org, jlayton@poochiereds.net,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@suse.com, mattst88@gmail.com,
        mgorman@suse.de, mst@redhat.com, miklos@szeredi.hu,
        netdev@vger.kernel.org, oleg@redhat.com, Paul.Durrant@citrix.com,
        paulmck@linux.vnet.ibm.com, pefoley2@pefoley.com, tgraf@suug.ch,
        therbert@google.com, willemb@google.com,
        xiaoguangrong@linux.vnet.ibm.com, zhenglong.cai@cs2c.com.cn
Subject: Re: [PATCH 0/6] kernel tinification: optionally compile out splice
 family of syscalls (splice, vmsplice, tee and sendfile)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Nov 2014 10:46:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Truly removing sendfile/sendpage means that you can't even compile NFS
into the tree.

I cannot take this patch series seriously, sorry.
