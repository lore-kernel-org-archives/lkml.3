Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab3KMKrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:47:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab3KMKrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:47:22 -0500
Date: Wed, 13 Nov 2013 11:47:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: input question: ambient light sensor button
In-Reply-To: <201309151553.34000@pali>
Message-ID: <alpine.LNX.2.00.1311131146410.22940@pobox.suse.cz>
References: <201309151553.34000@pali>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Sep 2013, Pali Rohár wrote:

> I do not know where to ask this question, but I think that kernel 
> developers could help me.
> 
> I have notebook with one special button on keyboard which is 
> designed for turning ambient light sensor on and off. By default 
> pressing button do nothing (I can turn ambient light sensor on/off 
> via sysfs platform wmi module). Button press is reported by 
> kernel input device AT Translated Set 2 keyboard and reports it 
> as button "touchpad off".
> 
> Of course "touchpad off" is incorrect and I'd like to ask which 
> kernel key or button from /usr/include/linux/input.h should be 
> mapped for my ambient light sensor button? Is there already some? 
> And what is strategy for allocating KEY_* and BTN_* numbers?

This is maintained by Dmitry, so he's the one to answer this. I am adding 
him to CC.

> I'd like to know this, so udev could have correct DMI keymap 
> hooks and other userspace programs can understand ambient light 
> sensor button correctly.

-- 
Jiri Kosina
SUSE Labs
