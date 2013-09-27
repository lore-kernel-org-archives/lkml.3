Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3I0EsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:48:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39523 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3I0EsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:48:17 -0400
Date: Fri, 27 Sep 2013 13:48:14 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v2 3/5] ARM: shmobile: r8a7790: add I2C DT nodes
Message-ID: <20130927044814.GB19749@verge.net.au>
References: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
 <1380216060-14506-4-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380216060-14506-4-git-send-email-g.liakhovetski@gmx.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 07:20:58PM +0200, Guennadi Liakhovetski wrote:
> Add DT nodes for the four I2C interfacces on r8a7790.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
> 
> v2: part two of former [PATCH 2/4], set i2c bus status to "disabled" by
> default.

Thanks, queued up for v3.13.
