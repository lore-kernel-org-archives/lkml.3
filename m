Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaKEJx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:53:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:19743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaKEJxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:53:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,319,1413270000"; 
   d="scan'208";a="602622003"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: "Fleming, Matt" <matt.fleming@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andy Lutomirski <luto@amacapital.net>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 0/3] Enable user helper interface for efi capsule
 update
Thread-Topic: [PATCH v2 0/3] Enable user helper interface for efi capsule
 update
Thread-Index: AQHP950O0ZFMfW+OGUuUUsUzWYiVbZxO5H4AgAABlgCAABkXAIAAAY4AgAAZVoCAAOILgIAB0LoQ
Date: Wed, 5 Nov 2014 09:52:56 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B80EF20@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <5457D883.4050201@amacapital.net> <20141103212706.GE7379@kroah.com>
	 <CALCETrUNCuFvwkzbU4dWB0GH4mJKKV1e6jCNrSLVJe+n_et3kQ@mail.gmail.com>
	 <20141103230234.GA9427@kroah.com>
	 <CALCETrUtxqLaziC_f6iTEgKNhmTgJR6bOLJ=e=O22X_RsBc9sw@mail.gmail.com>
	 <20141104003849.GA15147@kroah.com>
 <1415110071.26277.28.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1415110071.26277.28.camel@mfleming-mobl1.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA59s2jk024712

> -----Original Message-----
> From: Fleming, Matt
> Sent: Tuesday, November 04, 2014 10:08 PM
> To: Greg Kroah-Hartman
> >
> > Good point, I don't know.
> >
> > Who ever wrote this code should know this, can someone please provide
> > a use-case for how this is all supposed to work?
> 
> That would be Wilson. He's wanting to use this to send updates to the
> firmware on the Intel Quark, I think.

Hi Matt,

I believe Greg already got that from the commit message on my patch 3/3. Thanks.


Regards,
Wilson
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
