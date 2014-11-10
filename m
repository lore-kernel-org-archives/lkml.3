Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaKJAQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:16:21 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54198 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJAQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:16:20 -0500
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
Date: Mon, 10 Nov 2014 08:16:16 +0800
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chen Weixiang <weixiangchen@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that '=',
 '<' and '=='
Message-ID: <20141110001616.GA4520@chenwx>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chen Weixiang <weixiangchen@gmail.com>,
	Marek Belisko <marek.belisko@gmail.com>,
	Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
	Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
	Daniel Dodge <danieldodgese@gmail.com>,
	Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
 <20141104000543.GA17516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104000543.GA17516@kroah.com>
User-Agent: Mutt/1.5.23 (b8a63730c848) (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:05:43PM -0800, Greg Kroah-Hartman wrote:
> On Sat, Nov 01, 2014 at 10:47:22AM +0800, Chen Weixiang wrote:
> > Remove following code style errors from ft1000/ft1000-usb/ft1000_debug.c
> > and ft1000/ft1000-pcmcia/ft1000_hw.c:
> > ERROR: spaces required around that '=' (ctx:VxV)
> > ERROR: spaces required around that '<' (ctx:VxV)
> > ERROR: spaces required around that '==' (ctx:VxV)
> > 
> > Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> > ---
> >  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |  6 ++---
> >  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 28 ++++++++++++------------
> >  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> This patch doesn't apply against my staging.git tree on git.kernel.org
> Please refresh the series against the staging-testing and resend.
> 
> thanks,
> 
> greg k-h

OK, I'll refesh the patch series on staging-testing branch.
Thanks.

-- 
Best regards,
Chen Weixiang (Alex)

