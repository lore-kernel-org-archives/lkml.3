Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3LAJ6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:58:48 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55290 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3LAJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:58:38 -0500
From: =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	 =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<ivo.g.dimitrov.75@gmail.com>
Reply-To: =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	   =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	  <ivo.g.dimitrov.75@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_=D0=94?= 
	<freemangordon@abv.bg>,
        sre@ring0.de, omar.ramirez@copitl.com, tony@atomide.com,
        felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com, ohad@wizery.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not
	a security problem
X-Mailer: Modest 3.90.7
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
	 <20131130220553.GA1901@kroah.com> <20131130225822.GA26031@amd.pavel.ucw.cz>
	  <201312011041.40071@pali>
In-Reply-To: <201312011041.40071@pali>
Content-Type: text/plain; charset=utf-8
Content-ID: <1385891913.11457.1.camel@Nokia-N900>
Date: Sun, 01 Dec 2013 11:58:33 +0200
Message-Id: <1385891913.11457.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can (and will) test whatever patches is needed. Also will try to get rid of uuid helpers and send a patch today.

On Sun Dec   1 11:41:39 2013 Pali Rohár <pali.rohar@gmail.com> wrote:
> On Saturday 30 November 2013 23:58:23 Pavel Machek wrote:
> > On Sat 2013-11-30 14:05:53, Greg KH wrote:
> > > On Sat, Nov 30, 2013 at 09:42:37PM +0100, Pavel Machek wrote:
> > > > mmap in tidspbridge is missing range-checks. For now, make
> > > > this interface root-only, so that it does not cause
> > > > security problems.
> > > 
> > > Please fix this properly and don't paper over the real
> > > problem here.
> > 
> > Well, if the driver is left uncompilable, I'm pretty sure it
> > will bitrot.
> > 
> 
> If you want to compile tidspbridge driver, you need this patch:
> https://gitorious.org/linux-n900/linux-n900/commit/b9adde42d5351467fa9d281190213bb652499577
> 
> Removing BROKEN is not enough.
> 
> > I do have the hardware, but I'm pretty sure current mailine
> > does not have enough support to boot Maemo, so it is non
> > trivial for me to test changes here.
> > 
> 
> Use linux-n900 tree, there are patches also for tidspbridge
> driver, so old maemo and new harmattan userspace can use it. But
> HD videos not working yet (due to another problem, search for
> OMAPFB: CMA allocation failures).
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com

