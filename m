Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaI2Lvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:51:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59486 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbaI2Lvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:51:44 -0400
X-Sasl-enc: i7ezzmiI8LzovGJ6BX6WJRU16v60F10kGE6FPmUwK9T2 1411991503
Date: Mon, 29 Sep 2014 08:51:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140929115137.GB20150@khazad-dum.debian.net>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919223512.GC2018@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919223512.GC2018@khazad-dum.debian.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014, Henrique de Moraes Holschuh wrote:
> On Fri, 19 Sep 2014, Henrique de Moraes Holschuh wrote:
> > I'm filling a bug on Debian glibc, asking them to blacklist HLE until
> > further notice.
> 
> FWIW, https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=762195

Also, glibc lock elision removed from Fedora 20, 21, rawhide due to this
issue:

http://journal.siddhesh.in/posts/buggy-hle-microcode-updates-and-sigills.html

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
