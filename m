Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3LDNOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:14:09 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:42364 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3LDNOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:14:06 -0500
Date: Wed, 4 Dec 2013 08:14:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Oliver Schinagl <oliver@schinagl.nl>
Cc: grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        hdegoede@redhat.com, oliver+list@schinagl.nl
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
Message-ID: <20131204131402.GG3158@htj.dyndns.org>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
 <1386159055-10264-3-git-send-email-oliver@schinagl.nl>
 <20131204123708.GD3158@htj.dyndns.org>
 <529F2677.3070208@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F2677.3070208@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 04, 2013 at 01:56:23PM +0100, Oliver Schinagl wrote:
> I took the imx driver as example, as I wasn't sure on where to
> start. But I don't think it's possible yet without improving
> ahci_platform as I suggested in the cover letter. So if
> ahci_platform needs to be improved, I guess a separate patch series
> would be more appropriate?
> 
> So would it be acceptable to have this as the 2nd (and last?)
> ahci_platform driver and go from there? Or do you want to block new
> ahci_XXX drivers until ahci_platform has been improved?

I don't want to block new drivers unconditionally but at least I want
to know which direction we're headed in the longer term.  Right now it
feels like we could be at the beginning of an uncoordinated explosion
of these drivers which will take a hell lot mpore effort to clean up
after the fact.  I could be wrong and these could actually be
different enough to justify separate drivers and there isn't gonna be
an avalanche of these but again I at least want to know the general
direction things are headed before making any decisions.

Thanks.

-- 
tejun
