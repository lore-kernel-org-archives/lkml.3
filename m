Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaC1QcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:32:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:36355 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC1Qb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:31:58 -0400
Date: Fri, 28 Mar 2014 09:31:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Fugang Duan <B38611@freescale.com>, Grant Likely <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Daniel Wagener <daniel.wagener@kernelconcepts.de>
Subject: Re: [PATCHv6 0/5] Input: edt-ft5x06: Add DT support
Message-ID: <20140328163154.GE22658@core.coreip.homeip.net>
References: <1395323075-12146-1-git-send-email-LW@KARO-electronics.de>
 <1395673870-29435-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395673870-29435-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 04:11:05PM +0100, Lothar Waßmann wrote:
> Changes wrt. v1:
> addressed the comments from Jingoo Han and Mark Rutland
> - added another patch to convert the driver to use devm_* functions
> - removed sysfs reference from bindings documentation
> - changed '_' to '-' in property name
> - added 'edt,' prefix to properties names
> - added sanity check for parameters read from DT
> - cleaned up the gpio handling code
> 
> Changes wrt. v2:
> - fixed the devm_* messup reported by Dmitry Torokhov
> - added unit for report-rate property to the binding doc
> - added separate patch to fix the reset delays
> 
> Changes wrt: v3:
> - removed patches that have already been applied in the mean time
> - ignore touchdown events, since those may report bad coordinates
> - added support for a new firmware version
> 
> Changes wrt: v4:
> - removed some empty lines in the cleanup patch
> - addressed comments by Mark Rutland concerning the binding doc
> - use of_property_read_u32() instead of of_property_get()
> - dropped the 'report_rate' property
> - addressed comments by Fugang Duan
> - added Daniel Wagener and myself to the Copyright header in the
>   source file
> - use msleep() rather than mdelay() for the reset/wake pin timing
> 
> Changes wrt: v5:
> - added missing '&' to parameter of of_property_read_u32()
> 

Applied, thank you.

-- 
Dmitry
