Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaLJMLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:11:33 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:43618 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLJMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:11:32 -0500
Date: Wed, 10 Dec 2014 12:11:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com,
        anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix platform-device id collision
Message-ID: <20141210121125.GC23481@x1>
References: <1418175593-23474-1-git-send-email-festevam@gmail.com>
 <20141210094649.GA23481@x1>
 <20141210111925.GP11764@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141210111925.GP11764@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Mark Brown wrote:

> On Wed, Dec 10, 2014 at 09:46:50AM +0000, Lee Jones wrote:
> > On Tue, 09 Dec 2014, Fabio Estevam wrote:
> 
> > > Tested on a imx53-qsb board, where multiple DA9053 regulators can be 
> > > successfully probed.
> 
> > Applied for v3.20, thanks.
> 
> Fabio was saying that -next is broken which presumably means that v3.19
> will be broken unless this gets sent as a fix.

My train of thought was that the original configuration has not
changed since 2011.  I guess other regulators have been recently
introduced.  Very well, applied to -fixes.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
