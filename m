Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaB0P1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:27:32 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16484 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaB0P12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:27:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7361"; a="59962339"
X-IronPort-AV: E=Sophos;i="4.97,555,1389772800"; 
   d="scan'208";a="600765514"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: David Herrmann <dh.herrmann@gmail.com>
CC: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: set NET_NAME_USER for P2P ifs
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
	<1393512434-1325-4-git-send-email-dh.herrmann@gmail.com>
Date: Thu, 27 Feb 2014 17:27:21 +0200
In-Reply-To: <1393512434-1325-4-git-send-email-dh.herrmann@gmail.com> (David
	Herrmann's message of "Thu, 27 Feb 2014 15:47:13 +0100")
Message-ID: <87bnxsfuee.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Herrmann <dh.herrmann@gmail.com> writes:

> P2P netdevs and other devices that are created via nl80211 from user-space
> have a name provided by user-space. Therefore, set NET_NAME_USER so this
> is correctly shown in sysfs.
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Looks good to me.

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Can I take this to my ath.git tree?

-- 
Kalle Valo
