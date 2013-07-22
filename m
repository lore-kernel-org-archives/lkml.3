Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3GVCLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 22:11:07 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:42684 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246Ab3GVCLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 22:11:05 -0400
From: "Peng, Tao" <tao.peng@emc.com>
To: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alexandru Juncu <alexj@rosedu.org>, Pekka Enberg <penberg@kernel.org>,
        "andreas.dilger" <andreas.dilger@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lustre:libcfs: remove redundant code.
Thread-Topic: [PATCH] lustre:libcfs: remove redundant code.
Thread-Index: AQHOhI8JQ24YrnFsCkuay7Do0XLq/5lsXYWAgAABloCAAAIMgIAAAlMAgAAE0QCAAAXEAIADiPdw
Date: Mon, 22 Jul 2013 02:07:37 +0000
Message-ID: <1882637210201641A747464075FFC6490E5A7562@MX101CL02.corp.emc.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
	 <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
	 <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
	 <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
	 <CAPhGq=Y30i0RWJTcomt5sRdKX6RDzdGHBo5L9D6coH8O0ej6kA@mail.gmail.com>
	 <20130719154648.GA23116@kroah.com>
 <1374250046.15242.7.camel@x61.thuisdomein>
In-Reply-To: <1374250046.15242.7.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.218.56]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6M2BLPO006775

> -----Original Message-----
> From: Paul Bolle [mailto:pebolle@tiscali.nl]
> Sent: Saturday, July 20, 2013 12:07 AM
> To: Greg Kroah-Hartman
> Cc: Alexandru Juncu; Pekka Enberg; andreas.dilger; Peng, Tao; driverdev; LKML
> Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
> 
> On Fri, 2013-07-19 at 08:46 -0700, Greg Kroah-Hartman wrote:
> > Doesn't matter, if there are no users, please just remove it.
> 
> Is that, basically, your approach to staging cleanups?
> 
> I ask because I noticed that "drivers/staging/lustre/lustre/ptlrpc/gss/"
> is only built if CONFIG_PTLRPC_GSS is set. But the corresponding Kconfig
> symbol is nowhere to be found.
> 
That's my fault. We certainly _want_ the ptlrpc gss code. I'll get it fixed.

Thanks,
Tao

> Or do you prefer that I poke the people involved in (this case in)
> Lustre before suggesting a drastic cleanup like that?
> 
> 
> Paul Bolle
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
