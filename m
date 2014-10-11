Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaJKUbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:31:19 -0400
Received: from lvnode1.ve.v10networks.ca ([209.141.36.111]:46980 "EHLO
	lvnode1.ve.v10networks.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKUbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:31:18 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2014 16:31:18 EDT
Content-class: urn:content-classes:message
Subject: RE: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Date: Sat, 11 Oct 2014 13:22:11 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Thread-Index: AQHP5F6vAKuuUZSVZE66AaSXedI4EpwrK8AAgAAAzICAACKA4IAAB8PA
References: <20141010074901.GA32028@sucs.org> <20141011173902.GA1946@infradead.org> <1413049313.2068.48.camel@jarvis.lan> <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
From: "Jeff Leung" <jleung@v10networks.ca>
To: "KY Srinivasan" <kys@microsoft.com>,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Christoph Hellwig" <hch@infradead.org>
Cc: "Sitsofe Wheeler" <sitsofe@gmail.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Christoph Hellwig" <hch@lst.de>, "Hannes Reinecke" <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9BKVhx3011232

> On the current release of Windows (windows 10), we are advertising SPC3 compliance.
> We are ok with declaring compliance to SPC3 in our drivers.
If you are going to declare SPC3 compliance in the drivers, are you going to put in
checks to ensure that SPC-3 compliance doesn't get accidentally enabled for hypervisors below
Win10? 

I do know for a fact that Ubuntu's kernels already force SPC3 compliance to enable specific
features such as TRIM on earlier versions of Hyper-V (Namely Hyper-V 2012 and 2012 R2).

--Jeff

> Regards,
> 
> K. Y
> 
> 
> NryØ²XvØ–){nÇ‰{zX}zj:v zZzf~zwÚ¢)jyA
> 
> i
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
