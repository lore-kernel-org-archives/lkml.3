Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaIWEVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:21:04 -0400
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24402 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaIWEVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:21:01 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7569"; a="75299190"
X-IronPort-AV: E=Sophos;i="5.04,577,1406617200"; 
   d="scan'208";a="716074029"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH] ath: change logging functions to return void
References: <1411407334.2952.46.camel@joe-AO725>
Date: Tue, 23 Sep 2014 07:20:53 +0300
In-Reply-To: <1411407334.2952.46.camel@joe-AO725> (Joe Perches's message of
	"Mon, 22 Sep 2014 10:35:34 -0700")
Message-ID: <874mvzj7bu.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanexm01a.na.qualcomm.com (129.46.53.228) To
 NASANEXM01G.na.qualcomm.com (10.46.200.111)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> The return values are not used by callers of these functions
> so change the functions to return void.
>
> Other miscellanea:
>
> o add __printf verification to wil6210 logging functions
>   No format/argument mismatches found
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.
>
>  drivers/net/wireless/ath/ath10k/debug.c    | 18 +++++-------------
>  drivers/net/wireless/ath/ath10k/debug.h    |  6 +++---
>  drivers/net/wireless/ath/ath6kl/common.h   |  2 +-
>  drivers/net/wireless/ath/ath6kl/debug.c    | 28 ++++++++--------------------
>  drivers/net/wireless/ath/ath6kl/debug.h    | 13 ++++++-------

For ath6kl and ath10k:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

>  drivers/net/wireless/ath/wil6210/debug.c   | 14 ++++----------
>  drivers/net/wireless/ath/wil6210/wil6210.h |  7 +++++--
>  7 files changed, 32 insertions(+), 56 deletions(-)

John, as this patch also contains a wil6210 change how do you want to
handle this?

-- 
Kalle Valo
