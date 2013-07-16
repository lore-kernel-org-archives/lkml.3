Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab3GPUDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:03:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39697 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab3GPUDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:03:37 -0400
Date: Tue, 16 Jul 2013 13:03:36 -0700 (PDT)
Message-Id: <20130716.130336.215798833817030683.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        basil.gor@gmail.com
Subject: Re: [PATCH net 2/2] macvtap: do not assume 802.1Q when send vlan
 packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373952994-7252-2-git-send-email-jasowang@redhat.com>
References: <1373952994-7252-1-git-send-email-jasowang@redhat.com>
	<1373952994-7252-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Jul 2013 13:03:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 Jul 2013 13:36:34 +0800

> The hard-coded 8021.q proto will break 802.1ad traffic. So switch to use
> vlan->proto.
> 
> Cc: Basil Gor <basil.gor@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
