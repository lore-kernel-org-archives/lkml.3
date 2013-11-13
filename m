Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3KMQ2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:28:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45712 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3KMQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:28:44 -0500
Date: Wed, 13 Nov 2013 08:28:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: input question: ambient light sensor button
Message-ID: <20131113162840.GB11657@core.coreip.homeip.net>
References: <201309151553.34000@pali>
 <alpine.LNX.2.00.1311131146410.22940@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1311131146410.22940@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:47:18AM +0100, Jiri Kosina wrote:
> On Sun, 15 Sep 2013, Pali Rohár wrote:
> 
> > I do not know where to ask this question, but I think that kernel 
> > developers could help me.
> > 
> > I have notebook with one special button on keyboard which is 
> > designed for turning ambient light sensor on and off. By default 
> > pressing button do nothing (I can turn ambient light sensor on/off 
> > via sysfs platform wmi module). Button press is reported by 
> > kernel input device AT Translated Set 2 keyboard and reports it 
> > as button "touchpad off".
> > 
> > Of course "touchpad off" is incorrect and I'd like to ask which 
> > kernel key or button from /usr/include/linux/input.h should be 
> > mapped for my ambient light sensor button? Is there already some? 
> > And what is strategy for allocating KEY_* and BTN_* numbers?
> 
> This is maintained by Dmitry, so he's the one to answer this. I am adding 
> him to CC.

I guess we need patch adding

	#define KEY_ALS_TOGGLE	0x230

Thanks.

-- 
Dmitry
