Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3BLHgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:36:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47113 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab3BLHgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:36:33 -0500
Date: Tue, 12 Feb 2013 02:36:29 -0500 (EST)
Message-Id: <20130212.023629.1135481101302114772.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, edumazet@google.com,
        herton.krzesinski@canonical.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 185/222] tcp: fix MSG_SENDPAGE_NOTLAST logic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359740457.31386.74.camel@deadeye.wl.decadent.org.uk>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
	<1358351822-7675-186-git-send-email-herton.krzesinski@canonical.com>
	<1359740457.31386.74.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 01 Feb 2013 18:40:57 +0100

> On Wed, 2013-01-16 at 13:56 -0200, Herton Ronaldo Krzesinski wrote:
>> 3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> commit ae62ca7b03217be5e74759dc6d7698c95df498b3 upstream.
>> 
>> commit 35f9c09fe9c72e (tcp: tcp_sendpages() should call tcp_push() once)
>> added an internal flag : MSG_SENDPAGE_NOTLAST meant to be set on all
>> frags but the last one for a splice() call.
> [...]
> 
> David, I think this is needed for 3.0 and 3.2 as well since
> 35f9c09fe9c72e was backported to them.  You previously included it in
> updates for 3.4 and 3.7.

Ok, queued up, thanks.
