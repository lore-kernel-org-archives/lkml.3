Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaARXqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 18:46:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33125 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaARXqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 18:46:22 -0500
Date: Sun, 19 Jan 2014 00:46:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
Message-ID: <20140118234611.GJ15466@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
 <1390079163.25980.2.camel@x41>
 <CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
 <20140118221212.GB15543@pd.tnic>
 <CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
 <20140118223308.GH15466@pd.tnic>
 <CACPM=kVDpAFSWb3v8zS0+JE2U5C6pSNvqvL+aQ-npLtU05JGrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACPM=kVDpAFSWb3v8zS0+JE2U5C6pSNvqvL+aQ-npLtU05JGrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 12:24:10AM +0100, Bjarke Istrup Pedersen wrote:
> I have submitted a v2 patch - does it look better?

If you mean this:

 include/linux/hyperv.h      | 321 +----------------------------------------
 include/uapi/linux/Kbuild   |   1 +
 include/uapi/linux/hyperv.h | 344 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 347 insertions(+), 319 deletions(-)
 create mode 100644 include/uapi/linux/hyperv.h

you've got the rough idea of uapi headers :-).

Whether that makes sense at all in the hyperv case, you'll have to wait
for the hyperv guys to say something.

What makes me wonder is why do you need to export this now?

Because if those userspace hyperv tools would really need the
definitions in that header, then they never did build before. Which
would be really stupid. Btw, which userspace hyperv tools do you mean?
Where are they?

What am I missing?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
