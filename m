Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaAIKDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:03:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60193 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751745AbaAIKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:03:15 -0500
Date: Thu, 9 Jan 2014 10:02:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: tixy@linaro.org, patches@linaro.org, linaro-kernel@lists.linaro.org,
        Will Deacon <will.deacon@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH CFT] ARM:VERSATILE: Enable ARM_PATCH_PHYS_VIRT and
	AUTO_ZRELADDR by default
Message-ID: <20140109100259.GX27432@n2100.arm.linux.org.uk>
References: <1389248382-5262-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389248382-5262-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:49:42AM +0530, panchaxari wrote:
> This patch enables ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR as default configs
> to versatile platform.

NAK.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
