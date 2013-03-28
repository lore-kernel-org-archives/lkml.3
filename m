Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3C1Lm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:42:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3C1Lmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:42:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: Generic syscall ABI support
Date: Thu, 28 Mar 2013 11:42:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1364440182.2289.45.camel@leyfoon-vm> <201303281040.04463.arnd@arndb.de> <1364470251.3146.1.camel@leyfoon-vm>
In-Reply-To: <1364470251.3146.1.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281142.47631.arnd@arndb.de>
X-Provags-ID: V02:K0:ULCzgxZmxwqH21bXdfZXeL10w45kqwt+t764HNZ0LZ6
 b+NUFVj/qNoyTdkXx/7Cyy4BKUG3VQLMyZWLcQYIWbgW76k6cq
 d4KYRfaCjt67OqzaDwqG9b/kRMAQiOVlPvzwR074YQdyKF+n7P
 lVs6HbbQd34/0ifvcmzqLdAkKBiiNSP5waCNgUmB0wtoPBm0FD
 sHrsMxfIlus/ryX6PXbzqkXZnKPnwctwtfkFACgiYkmxojqOfW
 +bXi7cv5hr8+YmNhVVHwEBLVDmAhhodyy56jOP0dvl0jd+Yx5n
 D/mGhbCHA5dXaSULXkjiHQQNAxmFmtEOuaVBsdIn8vZiI32R6p
 B9e8QeWWbE5SUGosGGIo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Ley Foon Tan wrote:
> On Thu, 2013-03-28 at 10:40 +0000, Arnd Bergmann wrote:
> > On Thursday 28 March 2013, Ley Foon Tan wrote:
> > > We will working on generic ABI for kernel and Glibc. This might take
> > > some times.
> > 
> > Ok. Don't let that hold you up from submitting the kernel patches
> > for review though.
>
> Do you mean we can submit the patches for review before we got the
> generic ABI support?

I mean you can send the other patches for review already. Changing
your implementtion to use the generic ABI will basically just mean
not sending the patches tht implement your own ABI, so that's not
hard. Of course until you also have a new glibc port, you won't be
able to test that it actually works, but that is not essential for
the reviewing stage.

	Arnd
