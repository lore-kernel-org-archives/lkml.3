Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab3CAKmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:42:55 -0500
Received: from mx2.promwad.com ([91.149.128.90]:50667 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3CAKmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:42:53 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>, Ryan Mallon <rmallon@gmail.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH v2 00/11] staging: Support of TDM bus, TDM driver for Marvell Kirkwood and SLIC driver for Silabs Si3226x
Date: Fri, 1 Mar 2013 13:42:19 +0300
Message-ID: <cover.1362133319.git.michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361982152-5131-1-git-send-email-michail.kurachkin@promwad.com>
References: <1361982152-5131-1-git-send-email-michail.kurachkin@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michail Kurochkin (11):
  remove device_attribute
  added issues description in TODO file
  removing of buffer filling flag and also reverting old buffer related
    fix which is not really effective
  fixed e-mail address
  add issuses in TODO
  add issuses in TODO
  Initial commit of TDM core
  Initial commit of Kirkwood TDM driver
  Initial commit of SLIC si3226x driver
  added TODO file for si3226x
  refactoring request/free voice channels

 drivers/staging/Kconfig                            |    4 +
 drivers/staging/Makefile                           |    4 +-
 drivers/staging/si3226x/Kconfig                    |    9 +
 drivers/staging/si3226x/Makefile                   |    4 +
 drivers/staging/si3226x/TODO                       |   19 +
 drivers/staging/si3226x/si3226x_drv.c              | 1323 +++++++++++++++
 drivers/staging/si3226x/si3226x_drv.h              |  188 +++
 drivers/staging/si3226x/si3226x_hw.c               | 1691 ++++++++++++++++++++
 drivers/staging/si3226x/si3226x_hw.h               |  219 +++
 .../staging/si3226x/si3226x_patch_C_FB_2011MAY19.c |  176 ++
 drivers/staging/si3226x/si3226x_setup.c            | 1413 ++++++++++++++++
 drivers/staging/si3226x/slic_dtmf_table.c          |  127 ++
 drivers/staging/si3226x/slic_si3226x.h             |   75 +
 drivers/staging/tdm/Kconfig                        |   38 +
 drivers/staging/tdm/Makefile                       |   19 +
 drivers/staging/tdm/TODO                           |   16 +
 drivers/staging/tdm/kirkwood_tdm.c                 |  998 ++++++++++++
 drivers/staging/tdm/kirkwood_tdm.h                 |  112 ++
 drivers/staging/tdm/tdm.h                          |  293 ++++
 drivers/staging/tdm/tdm_core.c                     |  809 ++++++++++
 20 files changed, 7536 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/si3226x/Kconfig
 create mode 100644 drivers/staging/si3226x/Makefile
 create mode 100644 drivers/staging/si3226x/TODO
 create mode 100644 drivers/staging/si3226x/si3226x_drv.c
 create mode 100644 drivers/staging/si3226x/si3226x_drv.h
 create mode 100644 drivers/staging/si3226x/si3226x_hw.c
 create mode 100644 drivers/staging/si3226x/si3226x_hw.h
 create mode 100644 drivers/staging/si3226x/si3226x_patch_C_FB_2011MAY19.c
 create mode 100644 drivers/staging/si3226x/si3226x_setup.c
 create mode 100644 drivers/staging/si3226x/slic_dtmf_table.c
 create mode 100644 drivers/staging/si3226x/slic_si3226x.h
 create mode 100644 drivers/staging/tdm/Kconfig
 create mode 100644 drivers/staging/tdm/Makefile
 create mode 100644 drivers/staging/tdm/TODO
 create mode 100644 drivers/staging/tdm/kirkwood_tdm.c
 create mode 100644 drivers/staging/tdm/kirkwood_tdm.h
 create mode 100644 drivers/staging/tdm/tdm.h
 create mode 100644 drivers/staging/tdm/tdm_core.c

-- 
1.7.5.4

