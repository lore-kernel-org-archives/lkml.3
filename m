Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbbAFRpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:45:47 -0500
Received: from mailout.micron.com ([137.201.242.129]:31585 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbbAFRpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:45:45 -0500
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Nicholas Krause <xerofoify@gmail.com>, "axboe@fb.com" <axboe@fb.com>
CC: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa)" 
	<asamymuthupa@micron.com>,
        "hch@lst.de" <hch@lst.de>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] block:mtip32xx: Add call to set bit for failing drive
 rebuild in mtip32xx.c for the function,mtip_hw_get_identify
Thread-Topic: [PATCH] block:mtip32xx: Add call to set bit for failing drive
 rebuild in mtip32xx.c for the function,mtip_hw_get_identify
Thread-Index: AQHQKX+ybzOGMPKBr0Kmq4EHH6xlzZyzXbFw
Date: Tue, 6 Jan 2015 17:45:31 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A99462E383@NTXBOIMBX02.micron.com>
References: <1420526714-30488-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1420526714-30488-1-git-send-email-xerofoify@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21226.005
x-tm-as-result: No--33.704400-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Monday, January 05, 2015 10:45 PM
> To: axboe@fb.com
> Cc: Asai Thambi Samymuthu Pattrayasamy (asamymuthupa); Sam Bradshaw
> (sbradshaw); hch@lst.de; Selvan Mani (smani) [CONT - Type 2];
> agordeev@redhat.com; linux-kernel@vger.kernel.org
> Subject: [PATCH] block:mtip32xx: Add call to set bit for failing drive
> rebuild in mtip32xx.c for the function,mtip_hw_get_identify
> 
> This adds a call to the set_bit function for setting the bit for driver
> rebuild failures if the drive reset build fails based on checking the
> last element in the buf array for holding the value of the hardware
> registers.In additon we set this bit on the dd_flag element of the
> pointer dd of the structure type,driver_data passed to this function.

Thanks, Nicholas.  Good stuff.

Aside, if you're seeing rebuild failures, please contact Micron
support to get your drive(s) replaced under warranty.

-Sam
