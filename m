Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937143Ab3DKDBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:01:31 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42852 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762678Ab3DKDB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:01:29 -0400
Date: Thu, 11 Apr 2013 12:01:27 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH/RFC 4/6] ARM: shmobile: sh73a0: add support for the DMA0
 controller in DT
Message-ID: <20130411030127.GG21037@verge.net.au>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
 <1365632389-2249-5-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365632389-2249-5-git-send-email-g.liakhovetski@gmx.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 12:19:47AM +0200, Guennadi Liakhovetski wrote:
> Add a Device Tree node for the DMA0 controller on sh73a0 and
> auxdata to supply platform data to the driver. To enable the
> DMA0 controller it also has to be taken out of reset.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>


Hi Guennadi, this seems reasonable to me.

I guess the best thing is for you to repost it once the pre-requisites
are in place.
