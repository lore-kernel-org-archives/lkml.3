Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3GVQu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:50:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51868 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3GVQu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:50:56 -0400
Message-ID: <1374511851.3609.10.camel@hornet>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Mon, 22 Jul 2013 17:50:51 +0100
In-Reply-To: <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	 <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Jul 2013 16:50:51.0964 (UTC) FILETIME=[A000BFC0:01CE86FB]
X-MC-Unique: 113072217505401201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-20 at 04:19 +0100, Grant Likely wrote:
> +F:	include/dt-bindings

One thing we didn't finish talking about was the question if this
directory is supposed to contain *.dtsi files as well? The obvious
problem I have is a vexpress motherboard being (well, actually not bein
right now) shared between arch/arm/boot/dts and arch/arm64/boot/dts.

Pawel


