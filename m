Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3IAS7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 14:59:37 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37345 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3IAS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 14:59:36 -0400
Date: Sun, 1 Sep 2013 20:59:33 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Roberto Spadim <roberto@spadim.com.br>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: network stopped with a kernel error
Message-ID: <20130901185933.GA23936@electric-eye.fr.zoreil.com>
References: <CAH3kUhE5BLt=373NYiA4-GDmz4v5g4ekxT=Bo6U35fn0uhwmOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3kUhE5BLt=373NYiA4-GDmz4v5g4ekxT=Bo6U35fn0uhwmOw@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Spadim <roberto@spadim.com.br> :
[...]
> ethtool show eth2 and eth1 as up and running and eth2 as fibre but
> it's a TP board?!

It happens with old model r8169 boards that go south during netdev
whatchdog recovery handler.

Please send the XID line included in dmesg output at startup.

> i'm considering eth2 a broken board now, but please check if i'm wrong:

It may sitck stick until the device is not completely powered down / up.

> [beto@raja1 bonding]# cat /proc/version
> Linux version 2.6.39-ARCH (thomas@evey) (gcc version 4.6.0 20110603
> (prerelease) (GCC) ) #1 SMP PREEMPT Mon Jun 27 21:26:22 CEST 2011

It will help me if you have an URL for the sources of your kernel.

-- 
Ueimor
