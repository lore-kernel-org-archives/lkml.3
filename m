Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaIYMKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:10:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37509 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaIYMKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:10:14 -0400
Date: Thu, 25 Sep 2014 14:10:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925121007.GA25334@nazgul.tnic>
References: <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140925113643.GB10569@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 08:36:45AM -0300, Henrique de Moraes Holschuh wrote:
> This isn't an useless fix, it will allow systems without early initramfs
> support to operate correctly after a microcode update.

So what do we do if we update the microcode late and some userspace task
is using HLE and all of a sudden it segfaults and gets killed due to
#UD. I'll forward all those complaint emails to you then, no?

:-)

What's saying is, a reboot in this case is maybe the lesser of two evils.

-- 
Regards/Gruss,
    Boris.
--
