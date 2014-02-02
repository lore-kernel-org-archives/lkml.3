Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaBBMoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 07:44:09 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55234 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751183AbaBBMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 07:44:07 -0500
Date: Sun, 2 Feb 2014 12:43:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v5 00/23]
Message-ID: <20140202124358.GD26684@n2100.arm.linux.org.uk>
References: <cover.1390986082.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 10:01:22AM +0100, Jean-Francois Moine wrote:
> This patch set contains various extensions to the tda998x driver:
> 
> - simplify the i2c read/write
> - code cleanup and fix some small errors
> - use global constants
> - don't read write-only registers
> - add DT support
> - use IRQ for connection status and EDID read

I discussed these patches with Rob Clark recently, and the conclusion
we came to is that I'll merge them into a git tree, test them, and
once I'm happy I'll send a pull request as appropriate.

I'll go through them later today.  Those patches which have been re-
posted without any change for the last few times (the first few) I'll
take into my git tree today so you don't have to keep re-posting them
(more importantly, I won't have to keep on looking at them either.)

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
