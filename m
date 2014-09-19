Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaISNvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:51:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50539 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351AbaISNvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:51:21 -0400
X-Sasl-enc: xXaEjJb9t+VatQgfQv1jGiiTfvi/KmArFCrvVzf2o0wL 1411134680
Date: Fri, 19 Sep 2014 10:51:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919135108.GB17456@khazad-dum.debian.net>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919112953.GA3256@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014, Borislav Petkov wrote:
> On Fri, Sep 19, 2014 at 08:00:15AM -0300, Henrique de Moraes Holschuh wrote:
> > We're also killing microcode update support outside of the initramfs in
> > Debian.  It has become obvious that anything other than the early initramfs
> > method of microcode updates should be considered a developer thing.
> 
> That's simply not true: long-running systems which you can't reboot for
> whatever reason will need the late microcode update.

I have no plans to ask the Debian kernel team to disable the "microcode"
module.  The local system administrator is welcome to trigger the microcode
update manually: I will make sure to document how, although with a suitable
warning.

And I will also continue to pester you with patches to the microcode driver
:-)

But I will not trigger a microcode update when the intel-microcode package
gets updated/installed anymore.  The user will be warned of the need for
either a reboot or a manually triggered microcode update.

Anyway, those are my current plans.  I am delaying the microcode update in
non-free (Debian ancillary distro), so that I can reconsider the above as
the situation unfolds over the next week or two.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
