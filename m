Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaISOts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:49:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37233 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbaISOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:49:47 -0400
Date: Fri, 19 Sep 2014 16:49:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919144937.GB5318@nazgul.tnic>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919135108.GB17456@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140919135108.GB17456@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:51:08AM -0300, Henrique de Moraes Holschuh wrote:
> And I will also continue to pester you with patches to the microcode driver
> :-)

That's fine - I'm currently busy and not looking at them but I haven't
forgotten them.

> But I will not trigger a microcode update when the intel-microcode package
> gets updated/installed anymore.  The user will be warned of the need for
> either a reboot or a manually triggered microcode update.

That's also wrong - you need to warn only on the affected machines.

-- 
Regards/Gruss,
    Boris.
--
