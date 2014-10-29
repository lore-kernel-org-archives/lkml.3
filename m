Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaJ2DQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:16:17 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:3292 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbaJ2DQQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:16:16 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Joe Perches'" <joe@perches.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 29 Oct 2014 11:10:08 +0800
Subject: RE: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
Thread-Topic: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
Thread-Index: Ac/zJVEb9dfpFDzUQ92yzC+kZNCdrAAAGweA
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1825E@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
	 <1414392371.8884.2.camel@perches.com>
	 <1414531369.10912.14.camel@perches.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1825C@CNBJMBX05.corpusers.net>
 <1414551974.10912.16.camel@perches.com>
In-Reply-To: <1414551974.10912.16.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Perches [mailto:joe@perches.com]
> > I think the most safe way is change byte_rev_table[] to be satic, So
> > that no driver can access it directly, The build error can remind the
> > developer if they use byte_rev_table[] Directly .
> 
> You can do that with your later patch, but the existing uses _must_ be
> converted first so you don't break the build.
> 
> 
Yeah, I agree with you,
I will add this into my later patch.

Thanks
