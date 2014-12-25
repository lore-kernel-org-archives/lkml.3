Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLYXjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 18:39:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLYXjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 18:39:33 -0500
Date: Thu, 25 Dec 2014 18:39:30 -0500 (EST)
Message-Id: <20141225.183930.2234745020223954872.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
        sam@ravnborg.org, dave.kleikamp@oracle.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH repost 15/16] sparc/uaccess: fix sparse errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419499661-8566-16-git-send-email-mst@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
	<1419499661-8566-16-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Dec 2014 15:39:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 25 Dec 2014 11:30:22 +0200

> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Patches #14 and #15 have identical commit message header lines, you
need to say "sparc32: " or "sparc64: " so that shortlog scanners can
distinguish them.

Thanks.
