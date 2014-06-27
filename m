Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaF0Q3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:29:18 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:46754 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaF0Q3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:29:17 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:19a6:92bf:f0af:3806]
In-Reply-To: <20140627090303.GB23300@sirena.org.uk>
References: <20140620203858.GA14718@himangi-Dell>
	<1403849258-21779-1-git-send-email-olof@lixom.net>
	<20140627090303.GB23300@sirena.org.uk>
Date: Fri, 27 Jun 2014 09:29:16 -0700
Message-ID: <CAOesGMhOjiqix9wKto=e0xM5=8B1eXhnmEMGgY=jLOCad6VmkA@mail.gmail.com>
Subject: Re: [PATCH] spi: omap-uwire: fix compilation failure
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 2:03 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 26, 2014 at 11:07:38PM -0700, Olof Johansson wrote:
>> Patch 'spi: omap-uwire: use devm_ functions' (b3f6a57506b8) introduced a
>> build error due to a missing include file. Add it.
>
> A similar patch was applied a few days ago.

Ah, cool. I've seen the build breakage a couple of days including last
night's next and I didn't notice a patch for it based on a quick
search.

http://arm-soc.lixom.net/buildlogs/next/next-20140627/buildall.arm.omap1_defconfig.log.failed
http://arm-soc.lixom.net/buildlogs/next/next-20140626/buildall.arm.omap1_defconfig.log.failed


-Olof
