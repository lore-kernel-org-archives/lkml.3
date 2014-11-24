Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKXG4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:56:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34351 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKXG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:56:48 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-70-5472d6ab70ca
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/4] serial: samsung: fixes for serial driver
Date: Mon, 24 Nov 2014 07:56:20 +0100
Message-id: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t9jAd0114pCDM7/Z7WYs34Nm0Xz4vVs
	Fp9/72K1uLxrDpvFmcW97BZrj9xlt3hweCe7A7vHiRm/WTz2z13D7tG3ZRWjx5kFR9g9Pm+S
	C2CN4rJJSc3JLEst0rdL4MqYPHkSS8Fd1opJ884xNjBeZuli5OSQEDCROPbqPyuELSZx4d56
	ti5GLg4hgUWMEn82n4Ny2pkkrh87xARSxSagI7Hl+wRGEFtEQE7iye0/zCBFzALrGSVe3F/B
	DpIQFrCVaFk5hw3EZhFQldj1byUziM0r4CJxdfNTdoh1chInj01mncDIvYCRYRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcKA8k97BuKrB4hCjAAejEg/vjPVFIUKsiWXFlbmHGCU4mJVE
	eM/+KwwR4k1JrKxKLcqPLyrNSS0+xCjNwaIkznvjZm6IkEB6YklqdmpqQWoRTJaJg1OqgVGR
	jelcnoLUmbCFATfajI+W2J1xSHPadiprSfS+Tzc3B/XNUVnJqa3qo3lcbobOpb2ffXp/Lnk8
	pTrfJNda/ZTwxTQb7tQVEfzPNdffmqv24OHu7G6fVZu47J/uuydxpn7i+ctcFa9YvvwPSb3I
	4TAj5c2mI3+WmP950iMX8dylamHBdj4vPx4lluKMREMt5qLiRAA2XBEREAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series contains fixes for samsung serial driver. There is one patch
with important fix, which, I think, should be also applied to stable
trees, two patches fixing FIFO handling (they are not critical but,
they can provide better FIFO usage) and one patch with code cleanup.

Best regards,
Robert Baldyga

Robert Baldyga (4):
  serial: samsung: wait for transfer completion before clock disable
  serial: samsung: fix style problems
  serial: samsung: prefer to use fifosize from driver data
  serial: samsung: use port->fifosize instead of hardcoded values

 drivers/tty/serial/samsung.c | 63 ++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

-- 
1.9.1

