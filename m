Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaANAcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:32:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:9123 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaANAcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:32:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,656,1384329600"; 
   d="scan'208";a="458230223"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: RE: bug in sscanf()?
Thread-Topic: bug in sscanf()?
Thread-Index: Ac8NbKAkgHr1INwXQ8WF2Iu0CYn2gwDjdKaAAAHXLYAAELY/wA==
Date: Tue, 14 Jan 2014 00:32:13 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18465432C9C@ORSMSX105.amr.corp.intel.com>
References: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
	<20140113233006.GP10323@ZenIV.linux.org.uk>
 <CA+55aFy_V8ze2CPmHY0Ga-K-DX_SATVu-Tb=_nKq_1Rb5WqaUQ@mail.gmail.com>
In-Reply-To: <CA+55aFy_V8ze2CPmHY0Ga-K-DX_SATVu-Tb=_nKq_1Rb5WqaUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0E0WN9b027917

> -----Original Message-----
> From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus
> Torvalds
> Sent: Monday, January 13, 2014 4:23 PM
> To: Al Viro
> Cc: Allan, Bruce W; linux-kernel@vger.kernel.org; Jan Beulich; Alexey
> Dobriyan
> Subject: Re: bug in sscanf()?
> 
> On Tue, Jan 14, 2014 at 6:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Comments?
> 
> Do we have actual users of this? Because I'd almost be inclined to say
> "we just don't support field widths on sscanf() and will warn" unless
> there are users.
> 
> We've done that before. The kernel has various limited functions. See
> the whole snprint() issue with %n, which we decided that supporting
> the full semantics was actually a big mistake and we actively
> *removed* code that had been misguidedly added just because people
> thought we should do everything a standard user library does..
> 
> Limiting our problem space is a *good* thing, not a bad thing.
> 
> If it's possible, of course, and we don't have nasty users.
> 
>            Linus

I was hoping to use sscanf() in this way for a driver I'm working on to support
Thunderbolt device authentication, but if it's too much to ask for I could probably
work around this.

Bruce.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
