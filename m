Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaLISr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:47:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLISr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:47:58 -0500
Date: Tue, 09 Dec 2014 13:47:55 -0500 (EST)
Message-Id: <20141209.134755.1876886084798738973.davem@davemloft.net>
To: pshelar@nicira.com
Cc: joestringer@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCHv11 net-next 2/2] openvswitch: Add support for unique
 flow IDs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CALnjE+o4tbQVTyVkzdOG8zj=qxPZ8Dv3vGHbYkBmghxsLgKkkw@mail.gmail.com>
References: <1417575363-13770-1-git-send-email-joestringer@nicira.com>
	<1417575363-13770-2-git-send-email-joestringer@nicira.com>
	<CALnjE+o4tbQVTyVkzdOG8zj=qxPZ8Dv3vGHbYkBmghxsLgKkkw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 10:47:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do not quote an entire patch just to add some simple feedback or
signoff/ack.

That means someone has to scroll past the entire patch in patchwork or
the mailing list archives, unnecessarily.

This is one of my largest pet peeves, please do not do this.

Thanks.
