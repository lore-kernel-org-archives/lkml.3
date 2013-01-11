Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3AKNNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:37 -0500
Received: from masquerade.micron.com ([137.201.242.130]:14779 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3AKNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:34 -0500
Message-ID: <50F00FF1.1090804@micron.com>
Date: Fri, 11 Jan 2013 18:43:21 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 0/3] mtip32xx: add trim support and couple of fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19546.007
X-TM-AS-Result: No--5.384500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series contain changes for trim support and couple of fixes

Asai Thambi S P (3):
  mtip32xx: add trim support
  mtip32xx: fix for driver hang after a command timeout
  mtip32xx: fix for crash when the device surprise removed during
    rebuild

 drivers/block/mtip32xx/mtip32xx.c |  120 +++++++++++++++++++++++++++++++++++--
 drivers/block/mtip32xx/mtip32xx.h |   18 ++++++
 2 files changed, 132 insertions(+), 6 deletions(-)

