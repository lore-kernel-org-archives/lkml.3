Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3IFLiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:38:52 -0400
Received: from void.printf.net ([89.145.121.20]:40672 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3IFLiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:38:51 -0400
From: Chris Ball <cjb@laptop.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kevin Hilman <khilman@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
	<81053150.gZpPo7ioCr@avalon>
	<CAGa+x87xcVBxc7_AV8mmGq8DWuhgA3EL6jiwqQD33terH4XPBg@mail.gmail.com>
	<5649106.WzMa2Sr8sS@avalon>
Date: Fri, 06 Sep 2013 12:38:44 +0100
In-Reply-To: <5649106.WzMa2Sr8sS@avalon> (Laurent Pinchart's message of "Thu,
	29 Aug 2013 16:59:11 +0200")
Message-ID: <86wqmurxh7.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 29 2013, Laurent Pinchart wrote:
>> Any progress on this?  linux-next builds are still failing for the
>> following defconfigs because of this removal:
>
> Chris, could you please drop 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() 
> callback from platform data" from your tree or revert it ?

Sorry for the delay.  I decided to revert instead of rebase, so I've
pushed a revert to mmc-next now.  (I haven't sent mmc-next to mainline
yet.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
