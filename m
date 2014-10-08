Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbaJHLlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:41:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56972 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933900AbaJHLlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:41:44 -0400
Date: Wed, 8 Oct 2014 12:41:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
	SoC
Message-ID: <20141008114112.GG5182@n2100.arm.linux.org.uk>
References: <sbranden@broadcom.com> <1412746025-11998-1-git-send-email-sbranden@broadcom.com> <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <20141008081112.GB5182@n2100.arm.linux.org.uk> <54351D49.7040104@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54351D49.7040104@broadcom.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 04:17:29AM -0700, Scott Branden wrote:
> Thanks - was unaware of this functionality.  Will add .l2c_aux_val and  
> .l2c_aux mask to DT_MATCHINE_START.  BUT, what happens when we need to  
> add trustzone support and make SMC call to secure monitor?

You will then need to implement the .l2c_write_sec initialiser in the
same place.

Note that there's work to revise the trustzone support in this area
which will probably be merged for 3.19.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
