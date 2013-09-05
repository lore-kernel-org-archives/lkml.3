Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3IEUbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:31:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab3IEU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/7] 3.0.95-stable review
Date: Thu,  5 Sep 2013 13:28:33 -0700
Message-Id: <20130905202757.642048278@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.95 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep  7 20:27:46 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.95-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.95-rc1

Roland Dreier <roland@purestorage.com>
    SCSI: sg: Fix user memory corruption when SG_IO is interrupted by a signal

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix trailing ASCII space usage in INQUIRY vendor+model

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Helmut Schaa <helmut.schaa@googlemail.com>
    ath9k_htc: Restore skb headroom when returning skb to mac80211

Russ Anderson <rja@sgi.com>
    drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Takashi Iwai <tiwai@suse.de>
    ALSA: opti9xx: Fix conflicting driver object name

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix readdir cookie incompatibility with NFSv4


-------------

Diffstat:

 Makefile                                      |  4 ++--
 drivers/acpi/ec.c                             |  4 ++++
 drivers/base/memory.c                         |  2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 +++++++++
 drivers/target/target_core_cdb.c              | 11 +++++-----
 fs/bio.c                                      | 20 ++++++++++++-----
 fs/jfs/jfs_dtree.c                            | 31 ++++++++++++++++++++-------
 sound/isa/opti9xx/opti92x-ad1848.c            |  8 ++-----
 8 files changed, 64 insertions(+), 26 deletions(-)


