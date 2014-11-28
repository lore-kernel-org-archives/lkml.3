Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaK1RQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:16:51 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:59346 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaK1RQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:16:50 -0500
Date: Fri, 28 Nov 2014 18:16:39 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sandeep Nair <sandeep_n@ti.com>, linux-soc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] MIPS: BCM47XX: Move NVRAM driver to the drivers/soc/
Message-ID: <20141128171639.GC30648@linux-mips.org>
References: <1416736241-12723-1-git-send-email-zajec5@gmail.com>
 <1416778509-31502-1-git-send-email-zajec5@gmail.com>
 <alpine.DEB.2.02.1411240910100.16047@utopia.booyaka.com>
 <CACna6rxwwn5_e86278TAiOFZ3sVu_Exfm2x94vN2KiTJfsFujQ@mail.gmail.com>
 <alpine.DEB.2.02.1411251407290.16047@utopia.booyaka.com>
 <CACna6rxj8=V8me1_L8SxhV3=kgYRyKeBHkxShSMZa4kbcHimLg@mail.gmail.com>
 <alpine.DEB.2.02.1411271926560.1406@utopia.booyaka.com>
 <CACna6rwMjOfmnA-926udNx7jQHQ2JMnmiutQZkTxtJ85qmUw8A@mail.gmail.com>
 <alpine.DEB.2.02.1411281659190.1406@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411281659190.1406@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 05:07:12PM +0000, Paul Walmsley wrote:

> If I were in your shoes, I would suggest either
> 
> 1. asking Ralf to merge your patches that touch drivers/firmware, since 
> he'll also presumably be merging the parts that touch arch/mips
> 
> or 
> 
> 2. asking Greg KH to merge those patches
> 
> And of course it would not hurt to collect some Reviewed-By:s from other 
> folks.  (See below...)

I surely can carry this patch.

  Ralf
