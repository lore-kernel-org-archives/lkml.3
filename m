Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3JYPGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:06:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54786 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3JYPG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:06:29 -0400
Message-ID: <526A88DE.2040502@zytor.com>
Date: Fri, 25 Oct 2013 16:06:06 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Josh Triplett <josh@joshtriplett.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Tao Ma <boyu.mt@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Documentation/ABI: Document the non-ABI status of Kconfig
 and symbols
References: <20131024084104.GA2861@leaf> <CAFLxGvzqoJFHjXJ=WMR6Dyjg804=x0CkqHV2gXSfKUBgx2ktVA@mail.gmail.com>
In-Reply-To: <CAFLxGvzqoJFHjXJ=WMR6Dyjg804=x0CkqHV2gXSfKUBgx2ktVA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 09:57 AM, Richard Weinberger wrote:
> 
> And what about the kernel make "interface", is it considered also as non-ABI?
> 
> E.g.
> Before ffee0de (x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT)
> "make defconfig ARCH=x86" produced a i386 defconfig. Now it produces a
> x86_64 defconfig.
> I'm sure some build scripted failed badly.
> 
> 

Definitely not ABI, although obviously not a completely "break blindly"
either.

	-hpa

