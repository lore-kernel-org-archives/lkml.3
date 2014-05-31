Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaEaMgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 08:36:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40499 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756411AbaEaMge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 08:36:34 -0400
Date: Sat, 31 May 2014 13:35:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: srinivas.kandagatla@linaro.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH v5 02/13] mmc: mmci: convert register bits to use BIT()
	macro.
Message-ID: <20140531123502.GB20736@n2100.arm.linux.org.uk>
References: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org> <1401469980-26906-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401469980-26906-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 06:13:00PM +0100, srinivas.kandagatla@linaro.org wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> This patch converts the register bits in the header file to use BIT(()
> macro, which looks much neater.
> 
> No functional changes done.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This makes me wonder when we're going to get these definitions in the kernel
source, and have people running around making the conversion:

#define ZERO 0
#define ONE 1
#define TWO 2
#define THREE 3
#define FOUR 4
...

because allegedly it makes it more "readable".  I don't see much benefit
to this patch.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
