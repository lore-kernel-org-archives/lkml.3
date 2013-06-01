Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3FAMRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 08:17:32 -0400
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13653 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3FAMRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 08:17:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,783,1363158000"; 
   d="scan'208";a="42910068"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Unify sg_sz and buf_sz in ath6kl_sdio_alloc_prep_scat_req()
References: <1366804954-20491-1-git-send-email-geert@linux-m68k.org>
Date: Sat, 1 Jun 2013 15:17:14 +0300
In-Reply-To: <1366804954-20491-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Wed, 24 Apr 2013 14:02:34 +0200")
Message-ID: <87fvx2nhyt.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> sg_sz and buf_sz are initialized and used in a mutual exclusive way.
> However, some versions of gcc are not smart enough to see this:
>
> drivers/net/wireless/ath/ath6kl/sdio.c: In function ‘ath6kl_sdio_alloc_prep_scat_req’:
> drivers/net/wireless/ath/ath6kl/sdio.c:338: warning: ‘sg_sz’ may be used uninitialized in this function
>
> Unify the sg_sz and buf_sz variables into a single size variable to kill
> the compiler warning.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks, applied. Sorry for taking so long.

-- 
Kalle Valo
