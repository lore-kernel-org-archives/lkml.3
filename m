Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaFXVSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:18:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaFXVSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:18:06 -0400
Date: Tue, 24 Jun 2014 23:18:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        stable <stable@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86_32,entry: Do syscall exit work on badsys
 (CVE-2014-4508)
Message-ID: <20140624211802.GC15068@pd.tnic>
References: <CA+5PVA70nFS8JZkL0-Q-1HjFHT5NA04275_M4WstjQMrpT+hrQ@mail.gmail.com>
 <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
 <20140624105108.GG4439@pd.tnic>
 <CALCETrUStJFrCJBO-QRzn7mbdUgbnFgzYNspiVKORMsU6DMDKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUStJFrCJBO-QRzn7mbdUgbnFgzYNspiVKORMsU6DMDKw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:53:25PM -0700, Andy Lutomirski wrote:
> It confirms my sense that no one knows how to test this stuff :-/
> It's pretty clear that no one has ever extensively hammered it.

Someone might've known at some point but who knows who knew. :-)

> I wonder how much could be effectively rewritten in C. I'm thinking of
> redoing most of the entry work in C, but that won't help here.

Whatever you do, you'll have to do testing yourself, I'm afraid, here
too. And then, after the patch is long committed and forgotten, someone
would resurface complaining that it breaks some obscure use case.

Eeh, the sad life of a kernel developer. :-\

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
