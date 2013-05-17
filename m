Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3EQKZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:25:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49516 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab3EQKZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:25:05 -0400
X-Sasl-enc: vPZYvYoBNIxAo49b2xzqYVkpTpIaz3kzO3/r1/8iMwIb 1368786298
Date: Fri, 17 May 2013 20:24:56 +1000
From: Robert Norris <robn@opera.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org,
        Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130517102456.GA28229@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
 <20130514231626.GA12961@pyro.melbourne.osa>
 <20130515112044.753bb7bb@endymion.delvare>
 <20130515112741.GA23766@pyro.melbourne.osa>
 <20130515214923.036dabdb@endymion.delvare>
 <20130516034455.GA19452@pyro.melbourne.osa>
 <20130517103622.5000d277@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517103622.5000d277@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:36:22AM +0200, Jean Delvare wrote:
> IPMI is still likely to access the SMBus controller. If there's a BMC
> in the machine, it can also access the SMBus slave with its own
> controller. It would be good to rule this out by disabling IPMI
> completely, removing the BMC from the machine if it has one, and
> checking if it makes the issue go away or not.

I think they do have a BMC (dmidecode would suggest so). I'll need to
confirm this, and then get the datacentre support guys to pull it (yeah,
messy - inherited machines on the other side of the world). It might
take a couple of days, I'll let you know how it goes.

Cheers,
Rob.
