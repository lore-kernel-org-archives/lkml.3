Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaJXKlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:41:08 -0400
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:52549 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbaJXKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:41:04 -0400
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:CC:
   Date:Subject:Thread-Topic:Thread-Index:Message-ID:
   References:In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version;
  b=sTVPvWseGiU2z9/i5CutJT08uc9YoLR2QiLke2iokmj6Y99Kj5uwyb5b
   aCFtZfepRyTYZPOk59eol8Ppaz4GmXppAKykzNyn3KRwfzmo9RJ0WIvIR
   B1Wk6tJSIVqReqWhJwgw32MN3Gn8VtbJ7LcdAM3qfmxO3jWWN5MpLte7Y
   uMxxDgFMYs0C9+BIJLr1Z0TyinjzR1a/FzKJu+Bd59TqN34ZnqCpAxTso
   hWl0s6nKogY4LpHbGfM/rfn8EFenF;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="5.04,779,1406584800"; 
   d="scan'208";a="211045402"
From: "Wilck, Martin" <martin.wilck@ts.fujitsu.com>
To: "trenn@suse.de" <trenn@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
        "minyard@acm.org" <minyard@acm.org>
Date: Fri, 24 Oct 2014 12:40:56 +0200
Subject: Re: [patch 1/3] ipmi: Setup ipmi_devintf automatically if
 ipmi_msghandler gets loaded
Thread-Topic: [patch 1/3] ipmi: Setup ipmi_devintf automatically if
 ipmi_msghandler gets loaded
Thread-Index: Ac/vdv5kZfir4aYAR2+EhUAWRgj04g==
Message-ID: <1414147256.8113.41.camel@pdbcooper.pdb.fsc.net>
References: <20141014144020.683892494@d46.suse.de>
	 <54414057.5020806@acm.org> <1413793733.2678.10.camel@pdbcooper.pdb.fsc.net>
	 <2294896.XUUpIPFQ25@d46>
In-Reply-To: <2294896.XUUpIPFQ25@d46>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9OAfCss022724

Thomas,

> > I vote for MODULE_SOFTDEP for upstream, and modalias for distros that
> > don't support MODULE_SOFTDEP yet.
> I vote for ipmi_msghandler.c renaming into ipmi_handler.c

sorry, I am not with you here. This is a small problem that should be
handled with small effort. Why apply a 3-part patch set for a problem
that can be solved with 2 modalias lines in user space?

Martin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
