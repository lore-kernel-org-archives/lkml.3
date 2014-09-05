Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbaIEOXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:23:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51099 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbaIEOX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:23:29 -0400
X-Sasl-enc: MAEA11t/Dv4P6So1BG+3pK1FWYMg/kl73OYeOpUcqWww 1409927008
Date: Fri, 5 Sep 2014 11:23:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140905142316.GC1511@khazad-dum.debian.net>
References: <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
 <20140902131651.GA10691@khazad-dum.debian.net>
 <20140903064015.GA3941@nazgul.tnic>
 <20140903124302.GA18507@khazad-dum.debian.net>
 <20140904154246.GA10884@nazgul.tnic>
 <20140904174509.GB26007@khazad-dum.debian.net>
 <20140905085000.GA11432@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905085000.GA11432@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2014, Borislav Petkov wrote:
> On Thu, Sep 04, 2014 at 02:45:10PM -0300, Henrique de Moraes Holschuh wrote:
> > Can we get it backported to -stable, please (3.10 and later)?
> 
> I don't see how stable rules apply here.

It would be better if this functionality was generally available where early
microcode loading is supported.  As far as stable/longterm kernel.org
kernels are concerned, I believe that'd be 3.10, 3.12 and 3.14.

But it is no big deal as far as I'm concerned.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
