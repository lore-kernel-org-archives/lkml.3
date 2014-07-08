Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaGHU0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:26:37 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:59627 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaGHU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:26:35 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:8cce:4220:32bc:b297]
In-Reply-To: <53BC4DD7.20906@codeaurora.org>
References: <53BC4DD7.20906@codeaurora.org>
Date: Tue, 8 Jul 2014 13:26:34 -0700
Message-ID: <CAOesGMipEeB9SxF7dsmwEXi6+_vJvaikFO5yUsqr6fxp8pTv1w@mail.gmail.com>
Subject: Re: a case for a common efuse API?
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 1:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> I added Tegra folks because I see that on Tegra this hardware is exposed
> via an SoC specific API, tegra_fuse_readl(), and an associated driver in
> drivers/misc/fuse/tegra/. Unfortunately I don't see any users of the API
> outside of the speedo code in the same directory and the sysfs bin
> attribute that may or may not be in use by some userspace code.

Note that I also turned down the pull request that houses the code
under drivers/misc.

This is the type of stuff we've been talking about needing a home for
somewhere, and drivers/soc was one of the ones mentioned for that. I
really don't like adding dependencies on a random driver from platform
code, for example.


-Olof
