Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3KIMJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 07:09:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab3KIMJy (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Sat, 9 Nov 2013 07:09:54 -0500
Date: Sat, 9 Nov 2013 12:09:52 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm831x: Use PM ops for shutdown
Message-ID: <20131109120952.GA6549@opensource.wolfsonmicro.com>
References: <1383936686-24041-1-git-send-email-broonie@kernel.org> <1383936686-24041-2-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383936686-24041-2-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:51:26PM +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> This helps move us towards removing the bus custom operations.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
