Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab3CTTkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:40:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3CTTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:40:37 -0400
Date: Wed, 20 Mar 2013 20:40:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2] mfd: as3711: add OF support
In-Reply-To: <20130302041547.GJ6610@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1303202034090.24222@axis700.grange>
References: <Pine.LNX.4.64.1302181049510.4526@axis700.grange>
 <20130302041547.GJ6610@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:0BNwMBFFY75Rm4QUew87Y7OsLDdgp3OghCU94pndAfz
 rHGpdf+blg1AuTxOK4K3yK6aV0NSjt2TyGELaGYDhMuMqFe/b4
 Z7unRal0metN0xNqrsP8u2QU1Xp0rfjNp8k8M7LqixzMLkcGd/
 Y4LA4YGTcaQ5ClrZYVLvW3O8ZFGqarvEKsI611Z4Kz9GakK/ZW
 8GInCTQj2JyBhsr/Y1zai4PI94g0ca2VGFtq5hh9cRZP6R8IJB
 RITez0MA5uuk2WnUiywx4xt3bRodF17axFiRjjj7a8oAVnLw7D
 CBdZ471pS0fvVB8vu3mA/VuRXn6icx1+Gug9rzJZOC39JBYV0i
 gEErBinK2cOSbYj0Q6XvRZLdqjHXkt+hUtSLZUxI6ckYD5JhbW
 AAJXbjTk1K74A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

On Sat, 2 Mar 2013, Mark Brown wrote:

> On Mon, Feb 18, 2013 at 10:57:44AM +0100, Guennadi Liakhovetski wrote:
> > Add device-tree bindings to the AS3711 regulator and backlight drivers.
> 
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This patch has been submitted more than a month ago and only has got one 
reviewed-be (thanks) and no comments otherwise. The patch touches multiple 
subsystems, so, it is a bit difficult to decide via which tree it should 
be pushed. Since the least trivial and largest portion of the patch is 
backlight-related, maybe Samuel could add his ack and then Andrew could 
pull it via his tree?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
