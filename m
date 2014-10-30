Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbaJ3NWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:22:42 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50684 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbaJ3NWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:22:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Date: Thu, 30 Oct 2014 15:22:49 +0200
Message-ID: <2020186.tp9cWKgsNl@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141030132136.GA23852@katana>
References: <2287003.09eTeKUr1V@avalon> <1441244.9DO8HMds24@avalon> <20141030132136.GA23852@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thursday 30 October 2014 14:21:36 Wolfram Sang wrote:
> > > See:
> > > 	9ec36cafe43b of/irq: do irq resolution in platform_get_irq
> > > 
> > > I suspect a similar thing could be done for I2C.
> > 
> > That could work. We would need to introduce a new i2c_get_irq() function
> > though. Wolfram, would you be fine with that ?
> 
> I'd think it will look pretty similar to platform_get_irq, no? That is
> fine with me.

It would, but as Thierry pointed out it should be possible to hide the details 
in the I2C core. I'll submit a patch shortly.

-- 
Regards,

Laurent Pinchart

