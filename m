Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaEULBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:01:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50078 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEULBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:01:11 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7444"; a="127582322"
X-IronPort-AV: E=Sophos;i="4.98,879,1392192000"; 
   d="scan'208";a="646004441"
Date: Wed, 21 May 2014 16:31:45 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        <ath9k-devel@venema.h4ckr.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [ath9k-devel] randconfig build error with next-20140519, in
 drivers/net/wireless/ath/ath9k/dfs.c
Message-ID: <20140521110143.GA2375@qca.qualcomm.com>
References: <CA+r1ZhiM7EK08Y4kriXMugMc1Mbj5VDUPwKMq8-_k8Q8qhwPtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhiM7EK08Y4kriXMugMc1Mbj5VDUPwKMq8-_k8Q8qhwPtw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 09:31:16AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> In file included from drivers/net/wireless/ath/ath9k/eeprom.h:22:0,
>                  from drivers/net/wireless/ath/ath9k/hw.h:27,
>                  from drivers/net/wireless/ath/ath9k/dfs.c:18:
> drivers/net/wireless/ath/ath9k/dfs.c: In function ‘ath9k_dfs_process_phyerr’:
> drivers/net/wireless/ath/ath9k/dfs.c:185:14: error: ‘struct ath_softc’
> has no member named ‘debug’
>     pe.ts - sc->debug.stats.dfs_stats.last_ts);
>               ^
> drivers/net/wireless/ath/ath9k/../ath.h:273:41: note: in definition of
> macro ‘ath_dbg’
>    ath_printk(KERN_DEBUG, common, fmt, ##__VA_ARGS__); \
>                                          ^
> drivers/net/wireless/ath/ath9k/dfs.c:186:5: error: ‘struct ath_softc’
> has no member named ‘debug’
>    sc->debug.stats.dfs_stats.last_ts = pe.ts;
>      ^
> make[5]: *** [drivers/net/wireless/ath/ath9k/dfs.o] Error 1

Please select CONFIG_ATH9K_DEBUGFS.

-Rajkumar
