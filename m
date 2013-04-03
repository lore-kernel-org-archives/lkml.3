Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab3DCOWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:22:34 -0400
Received: from masquerade.micron.com ([137.201.242.130]:41682 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3DCOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:22:33 -0400
Message-ID: <515C3B1C.8020801@micron.com>
Date: Wed, 3 Apr 2013 19:52:20 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>
Subject: [PATCH 0/3] mtip32xx: recovery improvement and fix for a crash
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19764.007
X-TM-AS-Result: No--5.520000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This patchset includes the following. It was generated against your for-3.9/drivers

* improved recovery for command timeout
* fix for a crash during rmmod
* add new debugfs entry 'device_status'


Asai Thambi S P (3):
  mtip32xx: recovery from command timeout
  mtip32xx: return 0 from pci probe in case of rebuild
  mtip32xx: Add debugfs entry device_status

 drivers/block/mtip32xx/mtip32xx.c |  327 ++++++++++++++++++++++++++-----------
 drivers/block/mtip32xx/mtip32xx.h |   18 ++-
 2 files changed, 243 insertions(+), 102 deletions(-)
