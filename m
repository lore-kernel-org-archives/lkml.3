Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3J2QE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:04:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40073 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3J2QE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:04:26 -0400
Date: Tue, 29 Oct 2013 11:03:12 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Gilad Avidov <gavidov@codeaurora.org>, linux-kernel@vger.kernel.org,
        Michael Bohan <mbohan@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 08/10] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20131029160312.GA23929@joshc.qualcomm.com>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <5a49bffc44c5f5bffe222560e489a712321ce971.1382985169.git.joshc@codeaurora.org>
 <20131029155605.GE4231@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029155605.GE4231@lee--X1>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:56:05AM -0700, Lee Jones wrote:
> On Mon, 28 Oct 2013, Josh Cartwright wrote:
> 
> > The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> > 800 series SoC family.  This driver exists largely as a glue mfd component,
> > it exists to be an owner of an SPMI regmap for children devices
> > described in device tree.
> > 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> >  drivers/mfd/Kconfig  | 10 ++++++++
> >  drivers/mfd/Makefile |  1 +
> >  drivers/mfd/pm8x41.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Can you CC me on your next submission, or it may not get applied.

Certainly.  Sorry about that.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
