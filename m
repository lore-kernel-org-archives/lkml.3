Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065Ab3GWT0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:26:20 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:57585 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900Ab3GWT0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:26:19 -0400
Date: Tue, 23 Jul 2013 15:26:15 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Pawel Moll <pawel.moll@arm.com>, Rob Herring <robherring2@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
In-Reply-To: <51EEC49A.4080909@wwwdotorg.org>
Message-ID: <alpine.LFD.2.03.1307231520280.15022@syhkavp.arg>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org> <1374290388-19308-3-git-send-email-grant.likely@linaro.org> <1374511851.3609.10.camel@hornet> <51ED9018.1020003@gmail.com> <1374599667.25700.92.camel@hornet>
 <51EEC49A.4080909@wwwdotorg.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Stephen Warren wrote:

> Or perhaps, we could move *.dts around in the kernel to match the
> proposed DT tree structure before that point in time?
> 
> >> we will still need
> >> to copy dt-bindings into the kernel. Also, I think we should move all
> >> dts files out of arch subdirs and arrange by vendor or soc family. I'm
> >> sure there are some cases that structure doesn't fit well, but there is
> >> very little in a dts tied to a cpu architecture.
> > 
> > I couldn't agree more. So:
> > 
> > <root>/include/dt-bindings/vendor/*?
> 
> > <root>/dts/vendor/*?
> 
> I would tend to prefer that option, ...

Please make a generic top-level directory for DT and move the dtc code 
in there as well.  Something like:

<root>/devicetree/dtc/*
<root>/devicetree/dts/*


Nicolas
