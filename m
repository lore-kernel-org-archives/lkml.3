Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaARWdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 17:33:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39188 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaARWdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 17:33:21 -0500
Date: Sat, 18 Jan 2014 23:33:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
Message-ID: <20140118223308.GH15466@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
 <1390079163.25980.2.camel@x41>
 <CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
 <20140118221212.GB15543@pd.tnic>
 <CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 11:24:53PM +0100, Bjarke Istrup Pedersen wrote:
> I should take all the parts the is not guarded by __KERNEL__, and move
> them to a uapi header, and then include it at the top of the normal
> header. Correct understood? :)

Yes, that's basically the approach but be conservative - export only
stuff which *really* is needed by userspace. And hyperv people should
sanity-check what you're exporting because once it is out, it is cast in
stone and there's no changing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
