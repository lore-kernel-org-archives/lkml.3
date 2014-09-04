Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaIDShI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:37:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:30498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbaIDShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:37:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381538338"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: early microcode: how to disable at runtime?
Thread-Topic: early microcode: how to disable at runtime?
Thread-Index: AQHPxVQ0XjqES+WILUWh6lQKeF7+w5vrk7uAgAAGcQCAAJdUgIAAvoqAgAATGACAABITgIAAE+yAgACxSgCAAHCVgIABI4aAgABlXQCAAcSMAP//udyw
Date: Thu, 4 Sep 2014 18:37:05 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A666A7F@ORSMSX106.amr.corp.intel.com>
References: <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic> <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
 <20140902131651.GA10691@khazad-dum.debian.net>
 <20140903064015.GA3941@nazgul.tnic>
 <20140903124302.GA18507@khazad-dum.debian.net>
 <20140904154246.GA10884@nazgul.tnic>
In-Reply-To: <20140904154246.GA10884@nazgul.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84IbFMQ012118

> From: Borislav Petkov [mailto:bp@alien8.de]
> > What I did claim is that it is going to be a far more user-friendly
> > stop gap than the "boot from rescue media" option.
> 
> Ok, we have it now and we can use it if needed. All is good.

Quoted comment from commit 65cef1311d5d212fd3d48a43678536dc878ca288:
"...This is useful mostly in debugging situations where we want to turn off microcode
    loading, both early from the initrd and late, ...."

In case this comment may cause confusion, I need to confirm that:

The parameter "dis_ucode_ldr" only turns off early microcode loading from the initrd.
It does not trun off loading microcode later during run time.

Thanks.

-Fenghua

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
