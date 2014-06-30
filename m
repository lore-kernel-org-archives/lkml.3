Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaF3Nz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:55:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207AbaF3Nz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:55:27 -0400
Date: Mon, 30 Jun 2014 15:39:48 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Antoine =?iso-8859-1?Q?T=E9nart'?=" 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140630133948.GB11880@kwain>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <000001cf8f9a$3045f3a0$90d1dae0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000001cf8f9a$3045f3a0$90d1dae0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 24, 2014 at 07:51:01PM +0900, Jingoo Han wrote:
> On Tuesday, June 24, 2014 7:35 PM, Antoine Tenart wrote:
> > 
> > Add a generic ChipIdea driver, with optional PHY and clock, to support
> > ChipIdea controllers that doesn't need specific functions.
> 
> s/doesn't/don't
> 
> > 
> > Needed for the Marvell Berlin SoCs SUB controllers.
> 
> s/SUB/USB

Right, I'll fix these.

> 
> > +
> > +MODULE_DESCRIPTION("Generic ChipIdea HDRC USB binding");
> > +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> > +MODULE_LICENSE("GPL");
> 
> How about "GPL v2"?

Well, "GPL" stands for "GNU Public License v2 or later" as documented
in:
http://lxr.free-electrons.com/source/include/linux/module.h#L100

Is there a reason I should use "GPLv2"? Or is this a best practice?

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
