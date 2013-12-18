Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3LRLJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:09:07 -0500
Received: from mx0.aculab.com ([213.249.233.131]:59884 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751007Ab3LRLJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:09:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: linux-next: build failure after merge of the net-next tree
Date: Wed, 18 Dec 2013 11:07:34 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B74A4@saturn3.aculab.com>
In-Reply-To: <CAMuHMdXHiKe6fjEHu0GrSVMAmvKuX9wOUdC2MW3uSjRAU5tnWA@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: Ac773RbXE/5TsDbESIGs2w1+u96xSQABBB8Q
References: <20131218125643.8ff140371e1f8c306327d354@canb.auug.org.au><20131217.212145.893665929052097867.davem@davemloft.net><20131217.213033.1019416869378407851.davem@davemloft.net><CAMuHMdUi4GQYR2p7enikEkTq1s-5YwirTzmo_tS0JwiE=dVmYw@mail.gmail.com><20131218101523.GP13532@twins.programming.kicks-ass.net> <CAMuHMdXHiKe6fjEHu0GrSVMAmvKuX9wOUdC2MW3uSjRAU5tnWA@mail.gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Peter Zijlstra" <peterz@infradead.org>
Cc: "David Miller" <davem@davemloft.net>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        "Linux-Next" <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ffusco@redhat.com>,
        <dborkman@redhat.com>, <tgraf@redhat.com>,
        "Joe Perches" <joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBIB9Cui009647

> > And sort(1) is annoying in that it doesn't do in-place sort; you'll end
> > up with empty files if you try the naive thing.
> >
> > Worse most of those Kbuild files include other random garbage, which
> > makes automated sorting harder still.
> >
> > So unless there's a sane and easy way to keep it sorted; I'm going to
> > ignore that rule.
> 
> Not keeping them sorted causes merge conflicts and duplicate/missing
> entries.

Edit in vi put cursor on the first line to be sorted and type !}sort
(assuming there is a nice blank line at the end).

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
