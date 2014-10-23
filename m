Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaJWTv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:51:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42530 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752137AbaJWTvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:51:55 -0400
Date: Thu, 23 Oct 2014 20:51:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Message-ID: <20141023195119.GL27405@n2100.arm.linux.org.uk>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
 <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
 <alpine.LFD.2.11.1410231542320.6969@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1410231542320.6969@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:47:32PM -0400, Nicolas Pitre wrote:
> On Wed, 22 Oct 2014, Catalin Marinas wrote:
> 
> > On Wed, Oct 22, 2014 at 05:06:23PM +0100, mathieu.poirier@linaro.org wrote:
> > > +#if __LINUX_ARM_ARCH__ >= 5
> > 
> > My old ARMv5 book does not list LDRD/STRD. It looks like they only come
> > with ARMv5TE. Are there any processors prior to this supported by the
> > kernel?
> 
> We still supports ARMv4 targets.
> 
> As far as I know, all the ARMv5 targets we support are also TE capable.

Not quite.  We have ARM1020, which according to our proc-*.S files is
only ARMv5T, not ARMv5TE.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
