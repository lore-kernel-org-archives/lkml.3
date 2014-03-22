Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaCVSnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:43:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:47978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaCVSnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:43:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,710,1389772800"; 
   d="scan'208";a="504624414"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of
 commands
Thread-Topic: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of
 commands
Thread-Index: AQHPRdoW0et51Pum40mA9yw1VIjQJ5rtKVCAgAAA2ACAAAaggIAADPWAgAAzQfA=
Date: Sat, 22 Mar 2014 18:43:47 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DB6D18@HASMSX103.ger.corp.intel.com>
References: <20140308010611.468206150@linuxfoundation.org>
	 <8891481.xyaW2OauMW@tux200s> <20140322162501.GA13385@kroah.com>
	 <174441141.AshFyuFNQG@tux200s> <20140322165145.GA12870@kroah.com>
 <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2MIiJaS007554

> On Sat, 2014-03-22 at 09:51 -0700, Greg Kroah-Hartman wrote:
> > On Sat, Mar 22, 2014 at 05:28:02PM +0100, Andreas Sturmlechner wrote:
> > > Original Message from: Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org>
> > > >
> > > > Does Linus's tree also have this problem for you?  Or does it work
> > > > there?  If it works there, perhaps we just missed backporting
> > > > something to 3.4?
> > > >
> > >
> > > Other trouble aside, iwlwifi works fine - writing this from today's
> > > build of 3.14.0-rc7+.
> >
> > Hm.  Any linux-wifi developers have an idea?  I can always just revert
> > this patch, but finding out the root cause would be nice...

Reverting the patch is obviously the first thing to do. Finding the root would be nice but I am afraid the time won't allow it... In any case, this patch is meant to avoid a few DMAR fault and possibly some calibration mismatch upon suspend resume. Nothing critical in my eyes.

> 
> Andreas, could you test whether this regression is also present in 3.2.55?
> This patch is based on my backport for 3.2.y.
> 
> Ben.
> 
> --
> Ben Hutchings
> I'm not a reverse psychological virus.  Please don't copy me into your sig.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
