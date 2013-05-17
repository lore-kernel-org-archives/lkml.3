Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3EQK0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:26:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56423 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab3EQK0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:26:31 -0400
X-Sasl-enc: s2Cu2bfYBYTTNnKrzEZzESRGiu/rUV1s7vAqGywyr25K 1368786390
Date: Fri, 17 May 2013 20:26:27 +1000
From: Robert Norris <robn@opera.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130517102627.GB28229@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
 <20130514231626.GA12961@pyro.melbourne.osa>
 <20130515112044.753bb7bb@endymion.delvare>
 <20130515112741.GA23766@pyro.melbourne.osa>
 <20130515214923.036dabdb@endymion.delvare>
 <20130516034455.GA19452@pyro.melbourne.osa>
 <20130517103622.5000d277@endymion.delvare>
 <CAGS+omA84dm8QxJS0vdrYkvD0YXshRh4EkQfqVpbwvNVH+HxQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omA84dm8QxJS0vdrYkvD0YXshRh4EkQfqVpbwvNVH+HxQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 05:54:33PM +0800, Daniel Kurtz wrote:
> Was Robert able to get the system working without hangs by disabling
> the IRQ feature of i2c-i801 module when it was builtin?

Yes. There are no hangs when interrupts are explicitly disabled with
disable_features=0x10 or when 6676a847 is reverted and the module
rebuilt.

Cheers,
Rob.

