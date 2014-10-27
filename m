Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaJ0RmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:42:11 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39895 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaJ0RmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:42:08 -0400
Date: Mon, 27 Oct 2014 10:42:02 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: b02247@freescale.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com
Subject: Re: [PATCH] ASoC: fsl-asoc-card: Don't bypass settings if cpu-dai is
 Master
Message-ID: <20141027174201.GA3408@Asurada>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
 <1414194502-14052-1-git-send-email-nicoleotsuka@gmail.com>
 <20141027173031.GA18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027173031.GA18557@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 05:30:31PM +0000, Mark Brown wrote:
> On Fri, Oct 24, 2014 at 04:48:11PM -0700, Nicolin Chen wrote:
> > When cpu-dai is the DAI Master (CBM_CFx), it may need some configurations,
> > set_sysclk() call for eample, for cpu-dai side in the hw_params(), even if
> > the set_bias_level() has already taken care of the codec-dai side.
> > 
> > So this patch just simply adds an additional condition.
> 
> This was threaded with another patch series - did you intend to submit
> this or did it get sent by accident?

I created this one without "--thread" (separately from that series) but
accidentally sent the patch along with the series in one git-send-mail
command. So I think I don't need to resend it since it's already there.

Please regard this one as one single patch.

Thank you.
Nicolin
