Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaHKVIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:08:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59007 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaHKVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:08:06 -0400
Date: Mon, 11 Aug 2014 14:08:05 -0700 (PDT)
Message-Id: <20140811.140805.1937682654021661445.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next v2] xen-netback: Don't deschedule NAPI when
 carrier off
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407758504-8150-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407758504-8150-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 14:08:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Mon, 11 Aug 2014 13:01:44 +0100

> In the patch called "xen-netback: Turn off the carrier if the guest is not able
> to receive" NAPI was descheduled when the carrier was set off. That's
> not what most of the drivers do, and we don't have any specific reason to do so
> as well, so revert that change.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Applied, thanks.
