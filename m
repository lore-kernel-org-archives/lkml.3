Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab3GPWNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:13:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3GPWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:13:32 -0400
Message-ID: <51E5C55C.4060609@infradead.org>
Date: Tue, 16 Jul 2013 15:12:44 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/v2] [trivial] treewide: Fix typo in printk
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com> <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/13 12:37, Masanari Iida wrote:
> Correct spelling typo in printk
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/crypto/ux500/hash/hash_core.c               | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 ++--
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c      | 2 +-
>  drivers/net/wireless/cw1200/wsm.c                   | 2 +-
>  drivers/net/wireless/iwlwifi/mvm/time-event.c       | 2 +-
>  drivers/net/wireless/rtlwifi/rtl8188ee/fw.c         | 4 ++--
>  drivers/net/wireless/rtlwifi/rtl8723ae/fw.c         | 4 ++--
>  drivers/power/88pm860x_charger.c                    | 4 ++--
>  drivers/power/pm2301_charger.c                      | 2 +-
>  drivers/scsi/lpfc/lpfc_attr.c                       | 8 ++++----
>  drivers/scsi/qla2xxx/qla_mr.c                       | 2 +-
>  11 files changed, 18 insertions(+), 18 deletions(-)



-- 
~Randy
