Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CFEoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:44:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60720 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3CFEoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:44:09 -0500
Date: Tue, 05 Mar 2013 23:44:07 -0500 (EST)
Message-Id: <20130305.234407.1723377842328472099.davem@davemloft.net>
To: peter@hurleysoftware.com
Cc: samuel@sortiz.org, sasha.levin@oracle.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] other ircomm_tty fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
References: <1362371063.3221.185.camel@thor.lan>
	<1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 20:44:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>
Date: Tue,  5 Mar 2013 11:09:03 -0500

> On Sun, 2013-03-03 at 23:24 -0500, Peter Hurley wrote:
>> In the meantime, while reviewing that code, I noticed there's a handful
>> of serious bugs in that one function that I'll send a patchset for.
> 
> As promised.
> 
> 
> Peter Hurley (4):
>   net/irda: Fix port open counts
>   net/irda: Hold port lock while bumping blocked_open
>   net/irda: Use barrier to set task state
>   net/irda: Raise dtr in non-blocking open

Series looks good, all applied, thanks Peter!
