Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaISIDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:03:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaISIDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:03:32 -0400
Date: Fri, 19 Sep 2014 10:03:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919080322.GB30491@nazgul.tnic>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <713c7342-bdf4-4e38-8de2-37d840d7028b@email.android.com>
 <CALCETrXaD01bHdpO9F1ukjhWnkusWuQ-M-FcJiqr47vWFUgGsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXaD01bHdpO9F1ukjhWnkusWuQ-M-FcJiqr47vWFUgGsg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 06:00:12PM -0700, Andy Lutomirski wrote:
> Yes, but how?  I assume that BIOS isn't switching between two
> different ucode blobs, and I don't know about any wrcpuid instruction.
> So there must be *some* way, at least on new ucode (and maybe on old
> ucode) to change that bit.

I'd venture a guess that WRMSR to some reg should give you that, if they
expose it.

-- 
Regards/Gruss,
    Boris.
--
