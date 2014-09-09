Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaIIIoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:44:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64993 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaIIIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:28 -0400
X-AuditID: cbfee61b-f79f86d00000144c-0d-540ebde97c9f
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/6] usb: dwc2/gadget: bugfixes for gadget driver
Date: Tue, 09 Sep 2014 10:44:07 +0200
Message-id: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t9jQd2Xe/lCDD60WVgcvF9v0bx4PZvF
	5V1z2CwWLWtltnj0cCurxYPDO9kd2Dz2z13D7tG3ZRWjx5b9nxk9jt/YzuTxeZNcAGsUl01K
	ak5mWWqRvl0CV8ah+RNYC3axVfze/5exgXEWaxcjJ4eEgInExvZv7BC2mMSFe+vZuhi5OIQE
	pjNK9MxexALhtDNJnNnVBVbFJqAjseX7BEYQW0RAXuL6xptgRcwC/YwSK2cvZgFJCAs4Svx8
	tpgZxGYRUJW4fecY2DpeAVeJiU8PsECsk5M4eWwy6wRG7gWMDKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxgoPjmfQOxlUNFocYBTgYlXh4M4L5QoRYE8uKK3MPMUpwMCuJ8F7ZDRTiTUms
	rEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXA6LyR//Dflrboj5v/
	iE6cGbpK2ivmoUn5POnwy+eqv7L8vTg9YIWn4dKVATXPJD9Fy78Sad/576LBoUzWk1wZFQ+k
	u1awGwoWrvmy8r7avNAky6cb1dsOd7fMvpNRmLiz7L75XrXGoJILTN4uwbXOBnv12VR5borf
	e3Bl1c93Z+b+/bD31+FZ8kosxRmJhlrMRcWJAGxGN8sKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have splitted my patchset "usb: dwc2/gadget: fix series" into two series.
This patch series contains fixes for dwc2/gadget driver. It's intended
for 3.17-final. I will also send this patches backported for stable.

Best regard
Robert Baldyga

Kamil Debski (2):
  usb: dwc2/gadget: fix phy disable sequence
  usb: dwc2/gadget: fix phy initialization sequence

Marek Szyprowski (3):
  usb: dwc2/gadget: break infinite loop in endpoint disable code
  usb: dwc2/gadget: do not call disconnect method in pullup
  usb: dwc2/gadget: delay enabling irq once hardware is configured
    properly

Robert Baldyga (1):
  usb: dwc2/gadget: avoid disabling ep0

 drivers/usb/dwc2/gadget.c | 52 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

-- 
1.9.1

