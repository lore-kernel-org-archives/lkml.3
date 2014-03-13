Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaCMMze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:55:34 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40775 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaCMMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:55:31 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the devicetree tree with the arm-soc tree
To: Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAOesGMiK-8_0vt7jWSMT3oaoPUz5fS92ztknC-HhsEYt2XCNZQ@mail.gmail.com>
References: <20140312220350.3c35bce7dff139a73a9c8262@kernel.org> < CAOesGMiK-8_0vt7jWSMT3oaoPUz5fS92ztknC-HhsEYt2XCNZQ@mail.gmail.com>
Date: Thu, 13 Mar 2014 12:55:21 +0000
Message-Id: <20140313125521.19449C41038@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 15:36:58 -0700, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Mar 12, 2014 at 3:03 PM, Mark Brown <broonie@kernel.org> wrote:
> > Hi Grant,
> >
> > Today's linux-next merge of the devicetree tree got a conflict in include/asm-generic/vmlinux.lds.h between commit 6c3ff8b11a16ec69 ("ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp") from the  tree and commit f618c4703a14672d27 ("drivers: of: add support for custom reserved memory drivers") from the devicetree tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> LGTM from the arm-soc side.

Ditto

g.

> 
> 
> -Olof

