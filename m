Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBSVbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:31:33 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:60820 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBSVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:31:32 -0500
Date: Wed, 19 Feb 2014 16:31:27 -0500
From: Matt Porter <mporter@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Christian Daudt <bcm@fixthebug.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>
Subject: Re: [PATCH] ARM: dts: remove bcm11351-brt.dts
Message-ID: <20140219213127.GL29906@beef>
References: <1392840808-28214-1-git-send-email-mporter@linaro.org>
 <53052059.3020105@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53052059.3020105@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 03:21:29PM -0600, Alex Elder wrote:
> On 02/19/2014 02:13 PM, Matt Porter wrote:
> > The BCM11351 BRT board will never see the light of day. Remove the BRT
> > dts since it is not maintainable.
> > 
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> 
> Please remove the line in the Makefile that refers to this file.
> Provided you make that change, it looks good to me.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>

Done, thanks.

-Matt
