Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaJXJX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:23:28 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47953 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbaJXJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:23:25 -0400
Date: Fri, 24 Oct 2014 10:23:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
Message-ID: <20141024092309.GC20534@e104818-lin.cambridge.arm.com>
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

On Thu, Oct 23, 2014 at 08:47:32PM +0100, Nicolas Pitre wrote:
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

Yes. What I meant is non-TE ARMv5 targets.

-- 
Catalin
