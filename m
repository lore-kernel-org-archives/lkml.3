Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbbAMWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:25:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbbAMWZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:25:26 -0500
Date: Tue, 13 Jan 2015 17:25:23 -0500 (EST)
Message-Id: <20150113.172523.1612644763021758959.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: linux-kernel@vger.kernel.org, ying.xue@windriver.com, Tero.Aho@coriant.com,
        jon.maloy@ericsson.com, allan.stephens@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] tipc: correctly handle releasing a not fully
 initialized sock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421171201-25224-1-git-send-email-sasha.levin@oracle.com>
References: <1421171201-25224-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 14:25:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Tue, 13 Jan 2015 12:46:41 -0500

> Commit "tipc: make tipc node table aware of net namespace" has added a
> dereference of sock->sk before making sure it's not NULL, which makes
> releasing a tipc socket NULL pointer dereference for sockets that are
> not fully initialized.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Good catch, applied, thanks.
