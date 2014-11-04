Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaKDDga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:36:30 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:23973 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaKDDg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:36:29 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "Kani, Toshimitsu" <toshi.kani@hp.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "yigal@plexistor.com" <yigal@plexistor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: RE: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for WT
Thread-Topic: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for WT
Thread-Index: AQHP8juoXLRxtX3zhkeUJSzf2kRDYZxPgA5QgAACt4CAAArfgIAAAfYAgABFedA=
Date: Tue, 4 Nov 2014 03:34:35 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295936556E@G4W3202.americas.hpqcorp.net>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com>
 <1414450545-14028-5-git-send-email-toshi.kani@hp.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593578ED@G9W0745.americas.hpqcorp.net>
 <1415052905.10958.39.camel@misato.fc.hp.com>
 <alpine.DEB.2.11.1411032352161.5308@nanos>
 <CALCETrXs0SotEmqs0B7rbnnqkLvMV+fzOJzNbp+y2U=zB+25OQ@mail.gmail.com>
In-Reply-To: <CALCETrXs0SotEmqs0B7rbnnqkLvMV+fzOJzNbp+y2U=zB+25OQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.193.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA43aiiS013016



> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Monday, November 03, 2014 5:01 PM
> To: Thomas Gleixner
> Cc: Kani, Toshimitsu; Elliott, Robert (Server Storage); hpa@zytor.com;
> mingo@redhat.com; akpm@linux-foundation.org; arnd@arndb.de; linux-
> mm@kvack.org; linux-kernel@vger.kernel.org; jgross@suse.com;
> stefan.bader@canonical.com; hmh@hmh.eng.br; yigal@plexistor.com;
> konrad.wilk@oracle.com
> Subject: Re: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for
> WT
> 
> On Mon, Nov 3, 2014 at 2:53 PM, Thomas Gleixner <tglx@linutronix.de>
> wrote:
...
> On the other hand, I thought that _GPL was supposed to be more about
> whether the thing using it is inherently a derived work of the Linux
> kernel.  Since WT is an Intel concept, not a Linux concept, then I
> think that this is a hard argument to make.

IBM System/360 Model 85 (1968) had write-through (i.e., store-through)
caching.  Intel might claim Write Combining, though.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
