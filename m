Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDAEF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:05:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDAEF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:05:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 0/6] 3.4.86-stable review
Date: Mon, 31 Mar 2014 21:07:50 -0700
Message-Id: <20140401032815.814334997@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.86 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr  3 03:28:04 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.86-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.86-rc1

Daniel Borkmann <dborkman@redhat.com>
    netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Artem Fetishev <artem_fetishev@epam.com>
    x86: fix boot on uniprocessor systems

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add manual min/max quirk for ThinkPad X240

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: synaptics - add manual min/max quirk

Theodore Ts'o <tytso@mit.edu>
    ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging: speakup: Prefix externally-visible symbols


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/x86/include/asm/topology.h          |   3 +-
 drivers/input/mouse/synaptics.c          |  55 +++++
 drivers/staging/speakup/i18n.c           |  12 +-
 drivers/staging/speakup/i18n.h           |  12 +-
 drivers/staging/speakup/keyhelp.c        |  36 +--
 drivers/staging/speakup/kobjects.c       |  80 +++----
 drivers/staging/speakup/main.c           | 366 +++++++++++++++----------------
 drivers/staging/speakup/selection.c      |  14 +-
 drivers/staging/speakup/serialio.c       |   6 +-
 drivers/staging/speakup/speakup.h        |  72 +++---
 drivers/staging/speakup/speakup_acntpc.c |   6 +-
 drivers/staging/speakup/speakup_acntsa.c |   2 +-
 drivers/staging/speakup/speakup_apollo.c |   8 +-
 drivers/staging/speakup/speakup_audptr.c |   2 +-
 drivers/staging/speakup/speakup_bns.c    |   2 +-
 drivers/staging/speakup/speakup_decext.c |   6 +-
 drivers/staging/speakup/speakup_decpc.c  |   4 +-
 drivers/staging/speakup/speakup_dectlk.c |   6 +-
 drivers/staging/speakup/speakup_dtlk.c   |   4 +-
 drivers/staging/speakup/speakup_dummy.c  |   2 +-
 drivers/staging/speakup/speakup_keypc.c  |   6 +-
 drivers/staging/speakup/speakup_ltlk.c   |   2 +-
 drivers/staging/speakup/speakup_spkout.c |   2 +-
 drivers/staging/speakup/speakup_txprt.c  |   2 +-
 drivers/staging/speakup/spk_priv.h       |   8 +-
 drivers/staging/speakup/synth.c          |  38 ++--
 drivers/staging/speakup/thread.c         |   4 +-
 drivers/staging/speakup/varhandlers.c    |  66 +++---
 fs/ext4/inode.c                          |  15 +-
 include/linux/bitops.h                   |  15 ++
 net/netfilter/nf_conntrack_proto_dccp.c  |   6 +-
 32 files changed, 470 insertions(+), 396 deletions(-)


