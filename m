Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaBMTkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:40:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35281 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750975AbaBMTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:40:23 -0500
Date: Thu, 13 Feb 2014 19:40:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] drm/i2c: tda998x: fix memory leak in case of i2c error
Message-ID: <20140213194009.GD30257@n2100.arm.linux.org.uk>
References: <20140213083316.38D7D822BD@smtp6-g21.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213083316.38D7D822BD@smtp6-g21.free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 09:13:34AM +0100, Jean-Francois Moine wrote:
> When the creation of the second i2c client was failing, the private
> buffer was not freed.
> 
> This bug was introduced by the commit 6ae668cc19e8
> 'drm/i2c: tda998x: check the CEC device creation'
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Since David got there first with his patch, which is identical to yours,
I'll take his description, and take this as an acked-by for it.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
