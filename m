Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423446Ab3CVW1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:27:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648Ab3CVW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:27:46 -0400
Date: Fri, 22 Mar 2013 23:27:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 2/3] regulator: as3711: add OF support
In-Reply-To: <20130322185333.GN22890@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1303222326430.22486@axis700.grange>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-3-git-send-email-g.liakhovetski@gmx.de>
 <20130322185333.GN22890@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:8L8IqwG0t+JFXqbtG9/8KjvcJGjV0jjfK+yWzPLoBhw
 dW0cPipmmxhgGUHpSlABXxl4MmDLMnFgbDPTFfmguaLGYBA3Yn
 k2h3JEnaGEZvMEbxVHdtJ6S8hwjxCt35HXH//vntooLgomPcYp
 m1QgkVHWmmAQEqQkSGtG+CiL8vJ2SLIbLiL7nwsZmbPJhes/KS
 6oKTzSUloTiS1l/VPIO9eZqK3K8SjQbk6TzooCo4mm1UYP9Ynq
 ARxYj8c6mc2AVfMF3uyM7izFkorhERYW010V8svBODj8+qQTQn
 HWKF2Zfcb+N8EDGtoETZCmV3pwCCfXZP3rj8F4zqSeiRbRoF1U
 A2DRhFQSpgqGkDNpNvNkvSdbrK14+2NG+fbu5XLNxTp3GZ7fJD
 qTwCcA9ATB7eQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Mark Brown wrote:

> On Fri, Mar 22, 2013 at 05:15:48PM +0100, Guennadi Liakhovetski wrote:
> > AS3711 regulator OF support only evaluates standard regulator DT
> > properties.
> 
> It looks like this has no dependencies on the MFD patch, is that
> correct?

Yes, that's correct. That was the purpose of this split - to pull the 
patches via respective trees.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
