Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3FGSuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:50:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51604 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab3FGSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:50:20 -0400
Date: Fri, 7 Jun 2013 20:50:15 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: mvebu: Add the i2c-bridge capability to
 the mv64xxx-i2c
Message-ID: <20130607205015.0a6d6bfd@skate>
In-Reply-To: <20130607180941.GW23859@titan.lakedaemon.net>
References: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com>
	<1370619743-15245-3-git-send-email-gregory.clement@free-electrons.com>
	<20130607180941.GW23859@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Fri, 7 Jun 2013 14:09:41 -0400, Jason Cooper wrote:

> > +- i2c,i2c-bridge : This flag indicate that the i2c controller have the
> > +  Transaction Generator support and we want to use it. Not all the
> > +  mv64xxx controller have this feature.
> 
> Do you have a list of which controllers definitely do, or definitely
> don't?  That would be helpful for folks adding new boards.

As mentioned in the first commit log:

""
This feature is currently only available on Armada XP, so usage of
this mechanism is activated through device tree.
""

So Armada XP is the only to have that, for now. We can probably assume
future Marvell SoC may also have this feature, but we don't know for
sure.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
