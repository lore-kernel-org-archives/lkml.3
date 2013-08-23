Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3HWOoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:44:20 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:34387 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3HWOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130823093559.GA10662@S2101-09.ap.freescale.net>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
	<CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
	<20130821123708.GA17748@b29396-Latitude-E6410>
	<20130823070906.GA2460@b29396-Latitude-E6410>
	<20130823075102.GA10424@S2101-09.ap.freescale.net>
	<20130823084954.GC2460@b29396-Latitude-E6410>
	<20130823093559.GA10662@S2101-09.ap.freescale.net>
Date: Fri, 23 Aug 2013 09:44:17 -0500
Message-ID: <CAHrpEqR7TEOz98TSFfbCaQ3pV5nGSLL4bZj+pu=g9cNfkCnFqg@mail.gmail.com>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
From: Frank Li <lznuaa@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <b29396@freescale.com>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/23 Shawn Guo <shawn.guo@linaro.org>:
> You can have all above environments defined in U-Boot mx6qsabreauto.h
> at compile time.  Then at runtime, you only need the following two
> commands to boot kernel with the device that you want.

I think uboot method is better than kernel.
