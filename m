Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084AbaDJJV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:21:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45396 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaDJJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:21:52 -0400
Date: Thu, 10 Apr 2014 11:21:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sorenb@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        punnaia@xilinx.com
Subject: Re: [RFC PATCH v2] edac: synopsys: Added EDAC support for zynq ddr
 ecc controller
Message-ID: <20140410092144.GD29093@pd.tnic>
References: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local>
 <20140408204047.GQ30077@pd.tnic>
 <534633C0.9090905@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <534633C0.9090905@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:01:36AM +0200, Michal Simek wrote:
> Just add it to Zynq maintainer fragment as we are doing for non
> zynq/xilinx drivers.

Yep, as a file pattern F:

> At least the is the first time when someone saying that only some
> functions should be documented.

I don't see the need to document simple functions which are *obvious*.
But if you want to do that, I'm not going to stop you so be my guest.


> I don't think this is good to do. When we remove this prefix entirely
> it is bigger chance that the same function name will be used by
> another driver. It is not a problem with linking but the same
> functions names will be listed in System.map which will complicate
> debugging.

Ok, fair enough. You probably still want to make them shorter, though,
so that your code doesn't have to be line-broken too much. For example,
since we only load a single edac driver per system, you can shorten the
prefix to "edac_" only.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
