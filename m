Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaIAKTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:19:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51603 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbaIAKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:19:33 -0400
X-Sasl-enc: by0gF7GvqBrB233197R136GgaWr8Lb0o6PbYrdwesnsf 1409566771
Date: Mon, 1 Sep 2014 07:19:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140901101919.GA2902@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901051302.GA28402@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Borislav Petkov wrote:
> On Sun, Aug 31, 2014 at 05:11:26PM -0300, Henrique de Moraes Holschuh wrote:
> > > Probably more like something more like arch/x86/boot/cmdline.c.  Maybe
> > > we could even make it sharable.
> > 
> > Looks like that would work, yes.
> 
> Guys, guys, please relax and check the code first: "dis_ucode_ldr".

Thanks!

Now we just need it added to Documentation/kernel-parameters.txt and to get
it backported to -stable.

This parameter is not a "debugging aid", it is a "save the day" bug
workaround aid...

I can't say I like the parameter name, though :p

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
