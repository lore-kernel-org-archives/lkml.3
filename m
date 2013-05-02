Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3EBGuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:50:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:17329 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3EBGud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:50:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,594,1363158000"; 
   d="scan'208";a="235723844"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC: "SamuelOrtiz@kroah.com" <SamuelOrtiz@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: mei file2alias compile error
Thread-Topic: mei file2alias compile error
Thread-Index: AQHORozcwyyJqi9mZkevdJJLBGK/UJjwcgwAgAEAeXA=
Date: Thu, 2 May 2013 06:50:13 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01F18E66@HASMSX106.ger.corp.intel.com>
References: <51814943.7000604@intel.com> <20130501182138.GA17550@kroah.com>
In-Reply-To: <20130501182138.GA17550@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r426oie1002045



> On Wed, May 01, 2013 at 09:56:35AM -0700, Dave Hansen wrote:
> > Linus's current git isn't compiling for me:
> >
> > >   HOSTCC  scripts/mod/file2alias.o
> > > /home/davehans/linux.git/scripts/mod/file2alias.c: In function
> â€˜do_mei_entryâ€™:
> > > /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: error:
> â€˜OFF_mei_cl_device_id_nameâ€™ undeclared (first use in this function)
> > > /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: note: each
> undeclared identifier is reported only once for each function it appears in
> > > /home/davehans/linux.git/scripts/mod/file2alias.c: At top level:
> > > /home/davehans/linux.git/scripts/mod/file2alias.c:1146:1: error:
> â€˜SIZE_mei_cl_device_idâ€™ undeclared here (not in a function)
> >
> > I confirmed that this commit: e5354107e is the one causing it for me.
> > My .config is here:
> >
> > 	http://sr71.net/~dave/linux/config-3.9-meibad
> >
> > Note that I don't even have CONFIG_INTEL_MEI enabled with this config.
> 
> I don't have CONFIG_INTEL_MEI set either, and I can't duplicate this.
> Samuel and Tomas, can you please track this down?

I cannot reproduce it as well. I've tried with v3.9 and also with the latest tip.

Thanks
Tomas
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
