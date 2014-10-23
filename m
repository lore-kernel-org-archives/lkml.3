Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaJWTrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:47:36 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:55527 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJWTrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:47:35 -0400
Date: Thu, 23 Oct 2014 15:47:32 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
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
In-Reply-To: <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.LFD.2.11.1410231542320.6969@knanqh.ubzr>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org> <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Catalin Marinas wrote:

> On Wed, Oct 22, 2014 at 05:06:23PM +0100, mathieu.poirier@linaro.org wrote:
> > +#if __LINUX_ARM_ARCH__ >= 5
> 
> My old ARMv5 book does not list LDRD/STRD. It looks like they only come
> with ARMv5TE. Are there any processors prior to this supported by the
> kernel?

We still supports ARMv4 targets.

As far as I know, all the ARMv5 targets we support are also TE capable.


Nicolas
