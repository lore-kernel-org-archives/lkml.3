Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbbAFSVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:21:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbbAFSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:21:49 -0500
Date: Tue, 06 Jan 2015 13:21:42 -0500 (EST)
Message-Id: <20150106.132142.1678595386163631972.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
        sam@ravnborg.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 14/40] sparc32/uaccess: fix sparse errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420558883-10131-15-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
	<1420558883-10131-15-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 10:21:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 6 Jan 2015 17:44:17 +0200

> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>


