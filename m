Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaIIIpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:45:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47122 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaIIIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:10 -0400
X-AuditID: cbfee61a-f79e46d00000134f-03-540ebe14a656
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/6] usb: dwc2/gadget: improvements for gadget driver
Date: Tue, 09 Sep 2014 10:44:51 +0200
Message-id: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jQV3RfXwhBh8mslgcvF9v0bx4PZvF
	5V1z2CwWLWtltnj0cCurxYPDO9kd2Dz2z13D7tG3ZRWjx5b9nxk9jt/YzuTxeZNcAGsUl01K
	ak5mWWqRvl0CV8atB/9YC2axVRx7uIutgbGBtYuRk0NCwERi8dGdTBC2mMSFe+vZuhi5OIQE
	pjNKTH12nxnCaWeSuPJ9MVgHm4COxJbvExhBbBEBeYnrG2+ygBQxC/QzSqycvZgFJCEs4CrR
	19vLBmKzCKhK3Nm9H6iZg4MXKN59IhNim5zEyWOTWScwci9gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERwaz6R2MK5ssDjEKMDBqMTDmxHMFyLEmlhWXJl7iFGCg1lJhPfKbqAQb0pi
	ZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxsO8/3YfdTe3zDh9
	PmammNyR9enJv/9MjF/7L3HGN1tfnuhty1x7XyVcYr77SN+4NCa9kZ/JNHBjofOfOfLtvl1M
	nnZTZu6xYNE4kR04zf3a+rhsbtMzLGZ1E2bPX1URdmzyT/eK7Pvp7rMj/s/6Mueb84tXq/77
	mYbzvXrn94b/9zWPL9kmnkosxRmJhlrMRcWJALnJ5AUJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have splitted my patchset "usb: dwc2/gadget: fix series" into two series.
This patch series contains improvements for dwc2/gadget driver. It's intended
for 3.18.

Andrzej Pietrasiewicz (1):
  usb: dwc2/gadget: Fix comment text

Kamil Debski (1):
  usb: dwc2/gadget: move phy bus legth initialization

Marek Szyprowski (2):
  usb: dwc2/gadget: hide some not really needed debug messages
  usb: dwc2/gadget: ensure that all fifos have correct memory buffers

Robert Baldyga (2):
  usb: dwc2/gadget: assign TX FIFO dynamically
  usb: dwc2/gadget: disable clock when it's not needed

 drivers/usb/dwc2/core.h   |   3 ++
 drivers/usb/dwc2/gadget.c | 132 +++++++++++++++++++++++++++++-----------------
 2 files changed, 86 insertions(+), 49 deletions(-)

-- 
1.9.1

