Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaFPJY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:24:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57440 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaFPJYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:24:55 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7470"; a="134679159"
X-IronPort-AV: E=Sophos;i="5.01,485,1400050800"; 
   d="scan'208";a="750468750"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <wcn36xx@lists.infradead.org>
Subject: Re: [PATCH -next 13/26] ath: Use dma_zalloc_coherent
References: <cover.1402863904.git.joe@perches.com>
	<55b103a2ec78c0031b348e103603bf9a0d9cac3b.1402863905.git.joe@perches.com>
Date: Mon, 16 Jun 2014 12:24:46 +0300
In-Reply-To: <55b103a2ec78c0031b348e103603bf9a0d9cac3b.1402863905.git.joe@perches.com>
	(Joe Perches's message of "Sun, 15 Jun 2014 13:37:42 -0700")
Message-ID: <87fvj52om9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
>
> Signed-off-by: Joe Perches <joe@perches.com>

For ath10k:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
