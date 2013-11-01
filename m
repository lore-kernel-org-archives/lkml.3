Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3KAUdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:33:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:48055 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3KAUdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:33:45 -0400
Message-ID: <1383338001.28909.42.camel@pasglop>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Sat, 02 Nov 2013 07:33:21 +1100
In-Reply-To: <20131101180459.81793C40A28@trevor.secretlab.ca>
References: <20131101145925.66e22f73@notabene.brown>
	 <1383279744.28909.26.camel@pasglop> <1383280054.28909.30.camel@pasglop>
	 <20131101160329.37f3707b@notabene.brown>
	 <1383282516.28909.36.camel@pasglop>
	 <20131101180459.81793C40A28@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 11:04 -0700, Grant Likely wrote:

> There are two problems here. First, making the change moves all the DT
> populated devices under the /sys/devices/platform tree, not just
> platform devices.

All DT populated *platform* devices. There are others that have their
own locations.

> Second, I expect there is going to be userspace breakage to move them.
> I've considered moving them before, but so far have felt that being
> tidier hasn't been worth the potential breakage. Userspace /shouldn't/
> be relying on the node name, but we all know that userspace always does
> what it should, right?
> 
> That said, I'm mostly concerned about breakage on Power machines, not on
> the ARM devices in this regard. If you are convinced that I'm worrying about
> nothing, then I'm fine with making the change. If anyone complains
> however then it will need to be reverted.

I don't see an issue with power.

Cheers,
Ben.


