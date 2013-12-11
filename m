Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3LKU0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:26:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59295 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3LKU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:26:35 -0500
Date: Wed, 11 Dec 2013 15:26:33 -0500 (EST)
Message-Id: <20131211.152633.1259772133334006433.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com,
        wuzhy@linux.vnet.ibm.com, mst@redhat.com
Subject: Re: [PATCH net V3 2/2] macvtap: signal truncated packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386738514-1502-2-git-send-email-jasowang@redhat.com>
References: <1386738514-1502-1-git-send-email-jasowang@redhat.com>
	<1386738514-1502-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 12:26:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 11 Dec 2013 13:08:34 +0800

> macvtap_put_user() never return a value grater than iov length, this in fact
> bypasses the truncated checking in macvtap_recvmsg(). Fix this by always
> returning the size of packet plus the possible vlan header to let the trunca
> checking work.
> 
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Also applied and queued up for -stable, thanks.
