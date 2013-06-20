Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3FTI0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:26:06 -0400
Received: from mout.gmx.net ([212.227.17.21]:55341 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab3FTI0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:26:04 -0400
X-Authenticated: #25030245
X-Provags-ID: V01U2FsdGVkX1/oBnRLDNzoDgc32tIafrkPfMZFky6LXVoqdLyN7c
	m7OBiSdQKSM1ha
Subject: Re: [PATCH] lp: implement proper detach function for parport_driver lp
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Hannes Weisbach <hannes_weisbach@gmx.net>
In-Reply-To: <20130619183231.GA7684@kroah.com>
Date: Thu, 20 Jun 2013 10:25:59 +0200
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8CE2C881-7D13-4F70-8F49-D932BE4D6120@gmx.net>
References: <2009349A-75FD-4D5F-8F25-F8FD78F1A5D8@gmx.net> <20130603210816.GA22677@kroah.com> <1EA8660C-5E07-42FC-91D4-7924BE87D5D7@gmx.net> <20130619183231.GA7684@kroah.com>
To: Greg Kroah-Hartman <greg@kroah.com>
X-Mailer: Apple Mail (2.1085)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 19.06.2013 um 20:32 schrieb Greg Kroah-Hartman:
> 
>> They are doing what I am doing: translating whatever the
>> user does on a /dev/parportN-node and sending device-specific commands
>> over USB.  When they do parport_announce_port(), lp.c should also be
>> initialized and they should have the same problem.
> 
> Why hasn't anyone reported that problem then?  Surely someone must use
> these, they've been in the kernel tree for over a decade now.
I don't know.  Maybe nobody uses them (anymore/ever)?  Nobody tried to
rmmod the kernel module or compiled the driver into the kernel?

The solution to the problem (if someone encountered it) was probably
policy-based: just don't unload the module.  The comment in lp.c is
clear: /* Write this some day.  */ ;)
