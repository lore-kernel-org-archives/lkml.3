Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaHVNVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:21:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48653 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756190AbaHVNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:21:30 -0400
Date: Fri, 22 Aug 2014 14:19:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140822131919.GX21734@leverpostej>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
 <20140514141914.446F7C4153D@trevor.secretlab.ca>
 <20140821140211.GD19293@ulmo.nvidia.com>
 <53F64624.5000403@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F64624.5000403@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 08:19:00PM +0100, Alexander Holler wrote:
> Am 21.08.2014 16:02, schrieb Thierry Reding:
> 
> > Anyway, those are all fairly standard reasons for where deferred probe
> > triggers, and since I do like deferred probe for it's simplicity and
> > reliability I'd rather not try to work around it if boot time is all
> > that people are concerned about.
> 
> It's neither simple nor reliable. It's non deterministic brutforcing 
> while making it almost impossible to identify real errors.

It's horrible, yes.

> In my humble opinion the worst way to solve something. I'm pretty sure 
> if I would have suggest such a solution, the maintainer crowd would have 
> eaten me without cooking.

We didn't have a better workable solution at the time. Having a hack
that got boards booting was considered better than not having them boot.
I don't remember people being particularly enthralled by the idea.

Thanks,
Mark.
