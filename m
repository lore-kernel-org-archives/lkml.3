Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3ALDmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 22:42:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab3ALDmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 22:42:19 -0500
Date: Fri, 11 Jan 2013 19:42:16 -0800 (PST)
Message-Id: <20130111.194216.884859016289350447.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, stefanha@redhat.com
Subject: Re: [PATCH V2 0/3] some fixes of tuntap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357959574-13113-1-git-send-email-jasowang@redhat.com>
References: <1357959574-13113-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Sat, 12 Jan 2013 10:59:31 +0800

> There series fixes two issues:
> - Don't allow calling TUNSETIFF when a file is detached which may cause kernel
> data structure corrupt.
> - Fix the reference count leaking of sock and module.
> 
> Plus a suggestion from Eric to use rtnl_dereference() instead of the open code.
> 
> Changes from v1:
> - don't use rcu to dereference tfile->detached as it was already protected by
> rtnl lock.
> - add a patch of switching to use rtnl_dereference().

All applied, thanks Jason.
