Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaI3KA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:00:29 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:51757 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaI3KA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:00:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the asm-generic tree
Date: Tue, 30 Sep 2014 12:00:10 +0200
Message-ID: <4061479.RDp9BKRgRN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930083116.753ae631@canb.auug.org.au>
References: <20140926200251.78f0d713@canb.auug.org.au> <6184197.FUKmdXcAaQ@wuerfel> <20140930083116.753ae631@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mIDAqe5G9WhhM+vDBpwHsWJWbl9Qi1jY0uFJIRb3C31
 6RlVaLEJ1ctDWeimaOblVyjiI+ZsRv95A2N8rUvDng6LOingNK
 T0PBRCRYknZjvXWGhrqE/bACNd/wcLZ0c54jPy7u65Fvjz506n
 ZpItNZZhVCWxoB3UXyc9fPsQ/VFPBPszTI77zQXriecInuUKFW
 if9bdqFIhBg7qOWaPLFEluqWx7rpBO5JjGPFnXDbMvXIquSoVS
 9G2Lo1cW45TRiVkaiadmg7796APlZYhCG0QI4ekPOvCZWJPCyq
 +xmZRcI1cFVuR3q2OLM/mf1XmT5+peMOF6E5Zsa+aTgi1VQtm/
 IVY6LIqyZqN0tFoeI940=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 08:31:16 Stephen Rothwell wrote:
> Hi Arnd,
> 
> On Fri, 26 Sep 2014 13:14:45 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Thanks, applied on top with Stephen's full report in the commit
> > message and your Ack.
> 
> I look at your tree today, and its empty ... just checking that you
> didn't forget to push or something.
> 

Thanks for the notification. I got overloaded with regressions and
ended up backing it all out for now. I still hope to get the subset
that Will did merged, but first need to split out some or all of
Thierry's patches that caused the regressions.

	Arnd
