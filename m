Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3CXIl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 04:41:56 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62528 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3CXIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 04:41:54 -0400
Date: Sun, 24 Mar 2013 11:40:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [-next] fs/eventpoll.c:545 suspicious rcu_dereference_check()
 usage
Message-ID: <20130324084036.GB2297@swordfish>
References: <20130322104248.GA2589@swordfish.minsk.epam.com>
 <20130323173422.GA13205@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323173422.GA13205@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/23/13 17:34), Eric Wong wrote:
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> > [    3.163894] ===============================
> > [    3.163895] [ INFO: suspicious RCU usage. ]
> > [    3.163897] 3.9.0-rc3-next-20130322-dbg-dirty #1 Not tainted
> > [    3.163898] -------------------------------
> > [    3.163900] fs/eventpoll.c:545 suspicious rcu_dereference_check() usage!
> 
> Sorry about this, I've fixed this and it is in the latest -mm
> 
> http://mid.gmane.org/20130321192748.6D86F31C23C@corp2gmr1-1.hot.corp.google.com
> 

thanks a lot.

	-ss
