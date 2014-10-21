Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaJUFTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:19:39 -0400
Received: from lvnode1.ve.v10networks.ca ([209.141.36.111]:50226 "EHLO
	lvnode1.ve.v10networks.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUFTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:19:38 -0400
Content-class: urn:content-classes:message
Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Date: Mon, 20 Oct 2014 22:19:31 -0700
Message-ID: <A70AC0C1B7E7FD478A6BF19705461AA01109B5@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <20141021044550.GC11691@sucs.org>
X-MS-Has-Attach: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Index: Ac/s6ewfh3Mv8Hf4TO2AcvD55p4YbwABJhAg
References: <20141010074901.GA32028@sucs.org> <20141011173902.GA1946@infradead.org> <1413049313.2068.48.camel@jarvis.lan> <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com> <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca> <da5106ddc725481784ed12bccb594980@BY2PR0301MB0711.namprd03.prod.outlook.com> <20141021044550.GC11691@sucs.org>
From: "Jeff Leung" <jleung@v10networks.ca>
To: "Sitsofe Wheeler" <sitsofe@gmail.com>, "KY Srinivasan" <kys@microsoft.com>
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Christoph Hellwig" <hch@lst.de>, "Hannes Reinecke" <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9L5K0DQ029234

> Is it OK to replace a scsi_level of SCSI-2 with SCSI_SPC_3? Additionally is it also OK to force
> SCSI_SPC_3 on Hyper-V 2008?

I would patch the driver accordingly to force the SPC-3 flag.

For a Win2k8 host, I don't know what the side effects are, so it's safe to say it's not a good idea to
Force SCSI_SPC_3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
