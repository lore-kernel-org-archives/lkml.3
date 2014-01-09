Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaAIKDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:03:44 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60211 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751768AbaAIKDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:03:30 -0500
Date: Thu, 9 Jan 2014 10:03:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: hsweeten@visionengravers.com, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Ryan Mallon <rmallon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH CFT] ARM:EP93XX: Enable ARM_PATCH_PHYS_VIRT and
	AUTO_ZRELADDR by default
Message-ID: <20140109100318.GZ27432@n2100.arm.linux.org.uk>
References: <1389259164-7442-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389259164-7442-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 02:49:24PM +0530, panchaxari wrote:
> This patch enables ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR as default configs
> to EP93XX platforms from Cirrus.

NAK.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
