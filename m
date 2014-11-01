Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaKAFZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:25:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41249 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaKAFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:25:10 -0400
Date: Sat, 1 Nov 2014 10:55:01 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Chen Weixiang <weixiangchen@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that '=',
 '<' and '=='
Message-ID: <20141101052501.GH3642@sudip-PC>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
 <20141101050535.GC3642@sudip-PC>
 <1414818870.31550.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414818870.31550.1.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:14:30PM -0700, Joe Perches wrote:
> On Sat, 2014-11-01 at 10:35 +0530, Sudip Mukherjee wrote:
> > On Sat, Nov 01, 2014 at 10:47:22AM +0800, Chen Weixiang wrote:
> > > Remove following code style errors from ft1000/ft1000-usb/ft1000_debug.c
> > > and ft1000/ft1000-pcmcia/ft1000_hw.c:
> > > ERROR: spaces required around that '=' (ctx:VxV)
> > > ERROR: spaces required around that '<' (ctx:VxV)
> > > ERROR: spaces required around that '==' (ctx:VxV)
> > > 
> > 
> > many whitespace errors in the patch.
> > checkpatch gives total: 8 errors, 23 warnings, 125 lines checked
> 
> When fixing one thing (like spacing), it's pretty
> expected to have more checkpatch errors.
> 
> It's a process, don't worry about most intermediate
> warnings when doing checkpatch cleanups.
> 
> Adding trailing spaces is not good, nearly every
> other type of message can be ignored.
> 
ok, just to verify, i thought of trying to generate a similar patch which will not give checkpatch errors.
but this patch is not applying to next-20141031.

thanks
sudip
