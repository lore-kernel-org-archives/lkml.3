Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaC1UDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:03:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40373 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaC1UDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:03:31 -0400
Date: Fri, 28 Mar 2014 16:03:28 -0400 (EDT)
Message-Id: <20140328.160328.580812868196852483.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@stressinduktion.org, tytso@mit.edu, dborkman@redhat.com
Subject: Re: [PATCH] random32: assign to network folks in MAINTAINERS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395900095-15254-1-git-send-email-sasha.levin@oracle.com>
References: <1395900095-15254-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Mar 2014 13:03:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Thu, 27 Mar 2014 02:01:34 -0400

> lib/random32.c was split out of the network code and is de-facto
> still maintained by the almighty net/ gods.
> 
> Make it a bit more official so that people who aren't aware of
> that know where to send their patches.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied.
