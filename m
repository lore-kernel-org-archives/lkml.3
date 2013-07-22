Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab3GVUDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:03:47 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40751 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3GVUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:03:46 -0400
Message-ID: <51ED9018.1020003@gmail.com>
Date: Mon, 22 Jul 2013 15:03:36 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>  <1374290388-19308-3-git-send-email-grant.likely@linaro.org> <1374511851.3609.10.camel@hornet>
In-Reply-To: <1374511851.3609.10.camel@hornet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 11:50 AM, Pawel Moll wrote:
> On Sat, 2013-07-20 at 04:19 +0100, Grant Likely wrote:
>> +F:	include/dt-bindings
> 
> One thing we didn't finish talking about was the question if this
> directory is supposed to contain *.dtsi files as well? The obvious
> problem I have is a vexpress motherboard being (well, actually not bein
> right now) shared between arch/arm/boot/dts and arch/arm64/boot/dts.

Please no. When we move dts files out of the kernel, we will still need
to copy dt-bindings into the kernel. Also, I think we should move all
dts files out of arch subdirs and arrange by vendor or soc family. I'm
sure there are some cases that structure doesn't fit well, but there is
very little in a dts tied to a cpu architecture.

Rob

> Pawel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

