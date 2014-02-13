Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaBMTqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35286 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752138AbaBMTqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:09 -0500
Date: Thu, 13 Feb 2014 19:46:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, moinejf@free.fr,
        linux-coverity@vger.kernel.org
Subject: Re: drm/i2c: tda998x: Fix memory leak in tda998x_encoder_init
	error path.
Message-ID: <20140213194604.GE30257@n2100.arm.linux.org.uk>
References: <20140212171058.6CCD6660CAF@gitolite.kernel.org> <20140213034751.GA26499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213034751.GA26499@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:47:51PM -0500, Dave Jones wrote:
> Commit 6ae668cc19e8b18df28cd67b3448d9abd79284a4 introduced a memory leak
> in the error path of tda998x_encoder_init
> 
> Picked up by the nightly Coverity scan. CID 1174076
>     
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Thanks Dave, patch applied, and will send to airlied soon.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
