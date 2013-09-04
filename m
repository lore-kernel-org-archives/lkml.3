Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715Ab3IDBmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:42:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53549 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761549Ab3IDBmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:42:04 -0400
Date: Tue, 03 Sep 2013 21:42:02 -0400 (EDT)
Message-Id: <20130903.214202.2007386986702943063.davem@davemloft.net>
To: tim.gardner@canonical.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        ebiederm@xmission.com, gaofeng@cn.fujitsu.com, joe@perches.com,
        vfalico@redhat.com
Subject: Re: [PATCH net-next v2] net: neighbour: Remove CONFIG_ARPD
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377779927-28500-1-git-send-email-tim.gardner@canonical.com>
References: <8761upbd6h.fsf@xmission.com>
	<1377779927-28500-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 18:42:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 29 Aug 2013 06:38:47 -0600

> This config option is superfluous in that it only guards a call
> to neigh_app_ns(). Enabling CONFIG_ARPD by default has no
> change in behavior. There will now be call to __neigh_notify()
> for each ARP resolution, which has no impact unless there is a
> user space daemon waiting to receive the notification, i.e.,
> the case for which CONFIG_ARPD was designed anyways.
> 
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
 ...
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Applied, thanks.
