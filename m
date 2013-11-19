Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3KTOhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:37:52 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56871 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3KTOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:37:47 -0500
Date: Tue, 19 Nov 2013 13:27:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: input question: ambient light sensor button
Message-ID: <20131119212736.GA25784@core.coreip.homeip.net>
References: <201309151553.34000@pali>
 <alpine.LNX.2.00.1311131146410.22940@pobox.suse.cz>
 <20131113162840.GB11657@core.coreip.homeip.net>
 <201311141302.33384@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311141302.33384@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 01:02:31PM +0100, Pali Rohár wrote:
> On Wednesday 13 November 2013 17:28:40 Dmitry Torokhov wrote:
> > On Wed, Nov 13, 2013 at 11:47:18AM +0100, Jiri Kosina wrote:
> > > On Sun, 15 Sep 2013, Pali Rohár wrote:
> > > > I do not know where to ask this question, but I think that
> > > > kernel developers could help me.
> > > > 
> > > > I have notebook with one special button on keyboard which
> > > > is designed for turning ambient light sensor on and off.
> > > > By default pressing button do nothing (I can turn ambient
> > > > light sensor on/off via sysfs platform wmi module).
> > > > Button press is reported by kernel input device AT
> > > > Translated Set 2 keyboard and reports it as button
> > > > "touchpad off".
> > > > 
> > > > Of course "touchpad off" is incorrect and I'd like to ask
> > > > which kernel key or button from
> > > > /usr/include/linux/input.h should be mapped for my
> > > > ambient light sensor button? Is there already some? And
> > > > what is strategy for allocating KEY_* and BTN_* numbers?
> > > 
> > > This is maintained by Dmitry, so he's the one to answer
> > > this. I am adding him to CC.
> > 
> > I guess we need patch adding
> > 
> > 	#define KEY_ALS_TOGGLE	0x230
> > 
> > Thanks.
> 
> So there is no good key for als yet?

No, but if you send me a patch adding it I will gladly apply it.

Thanks.

-- 
Dmitry
