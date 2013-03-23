Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3CWReX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:34:23 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:41841 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3CWReW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:34:22 -0400
Date: Sat, 23 Mar 2013 17:34:22 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [-next] fs/eventpoll.c:545 suspicious rcu_dereference_check()
 usage
Message-ID: <20130323173422.GA13205@dcvr.yhbt.net>
References: <20130322104248.GA2589@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322104248.GA2589@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> [    3.163894] ===============================
> [    3.163895] [ INFO: suspicious RCU usage. ]
> [    3.163897] 3.9.0-rc3-next-20130322-dbg-dirty #1 Not tainted
> [    3.163898] -------------------------------
> [    3.163900] fs/eventpoll.c:545 suspicious rcu_dereference_check() usage!

Sorry about this, I've fixed this and it is in the latest -mm

http://mid.gmane.org/20130321192748.6D86F31C23C@corp2gmr1-1.hot.corp.google.com
