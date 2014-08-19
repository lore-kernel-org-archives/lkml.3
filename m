Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHSKIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:08:16 -0400
Received: from svenfoo.org ([82.94.215.22]:52589 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaHSKIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:08:14 -0400
Message-ID: <53F3220B.9070302@zonque.org>
Date: Tue, 19 Aug 2014 12:08:11 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        balbi@ti.com, devicetree@vger.kernel.org
CC: gregkh@linuxfoundation.org, michals@xilinx.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, svemula@xilinx.com, anirudh@xilinx.com,
        sbhatta@xilinx.com
Subject: Re: [PATCH v4 2/2] usb: gadget: Add xilinx usb2 device support
References: <1406020130-20467-1-git-send-email-sbhatta@xilinx.com> <31c3ad1a-370a-4d0d-b392-8e7bb292f6aa@BN1AFFO11FD050.protection.gbl> <53F31F52.8060904@zonque.org>
In-Reply-To: <53F31F52.8060904@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 11:56 AM, Daniel Mack wrote:
> On 07/22/2014 11:08 AM, Subbaraya Sundeep Bhatta wrote:

>>  drivers/usb/gadget/Kconfig      |   14 +
>>  drivers/usb/gadget/Makefile     |    1 +
>>  drivers/usb/gadget/udc-xilinx.c | 2261 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 2276 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/usb/gadget/udc-xilinx.c
> 
> As your driver has a DT binding, you have to describe it in
> Documentation/devicetree/bindings.

Ah, sorry. I missed patch 1/2 which does that.


Thanks,
Daniel

