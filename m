Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3FPQji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 12:39:38 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:53738 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3FPQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 12:39:37 -0400
Date: Sun, 16 Jun 2013 18:39:21 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "opensource@tigusoft.pl" <opensource@tigusoft.pl>
Cc: linux-kernel@vger.kernel.org, security@debian.org
Subject: Re: hanging, and possible exploit/ddos from LAN for RTL and other
 cards (watchdog netdev)
Message-ID: <20130616163921.GA28368@electric-eye.fr.zoreil.com>
References: <201306160933.45961.opensource@tigusoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306160933.45961.opensource@tigusoft.pl>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

opensource@tigusoft.pl <opensource@tigusoft.pl> :
[...]
> Thanks for helping to debug and find this problem: tigusoft.pl , #grsecurity , 
> Arach , Admin2501 , R.Freeman 
> 
> 
> We await any instructions how to debug this further.

Please send the XID of Realtek devices you own ('dmesg | grep XID').
r8169 support level is not the same for all chipsets and kernel.

Also please identify the motherboards and see if the r8169 irq is
shared on some of those.

Besides the r8169 patch you added, you may test if clocksource=acpi_pm
makes a difference (courtesy of Lance Lassetter on netdev).

[...]
> We plan to re-test this on newest kernels as well,

You will be welcome.

> but it was decided the report should be sent without delaying more since
> at least for us it explained many of "strange" cases of linux computers
> hanging, so it might help other people out there too.

Despite what the subject of the mail suggests, there is no "exploit" though.
Right ?

-- 
Ueimor
