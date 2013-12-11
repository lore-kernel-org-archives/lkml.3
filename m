Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3LKU02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:26:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59289 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LKU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:26:25 -0500
Date: Wed, 11 Dec 2013 15:26:22 -0500 (EST)
Message-Id: <20131211.152622.282773097382499363.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com, mst@redhat.com, vyasevich@gmail.com
Subject: Re: [PATCH net V3 1/2] tun: unbreak truncated packet signalling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386738514-1502-1-git-send-email-jasowang@redhat.com>
References: <1386738514-1502-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 12:26:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 11 Dec 2013 13:08:33 +0800

> Commit 6680ec68eff47d36f67b4351bc9836fd6cba9532
> (tuntap: hardware vlan tx support) breaks the truncated packet signal by nev
> return a length greater than iov length in tun_put_user(). This patch fixes
> by always return the length of packet plus possible vlan header. Caller can
> detect the truncated packet by comparing the return value and the size of io
> length.
> 
> Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable.
