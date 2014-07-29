Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaG2WGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:06:41 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57867 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaG2WGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:06:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140729185529.GG17528@sirena.org.uk>
References: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
	<20140725053230.GT1857@lahna.fi.intel.com>
	<CAAQYJAtM79NJJtfNYda-yFk113nm-2D8gZE5x=gbnLt2_eUdzQ@mail.gmail.com>
	<20140729185529.GG17528@sirena.org.uk>
Date: Wed, 30 Jul 2014 00:06:38 +0200
Message-ID: <CAAQYJAtLVgqbs=n2gxyemDAoHhM=7PFJy9bqKUExTbC+1rSNMg@mail.gmail.com>
Subject: Re: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
From: Andrea Adami <andrea.adami@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, chiau.ee.chew@intel.com,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 8:55 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jul 29, 2014 at 06:13:06PM +0200, Andrea Adami wrote:
>
>> note that a previous version of the patch breaks spi on pxa machines:
>> tested on pxa250 poodle and pxa255 corgi.
>> The patch is included in linux-Yocto since 3.14.
>
> The interesting question is if this version works...

Happy to report that I could finally test on poodle/pxa250 the current
v2 and the patch doesn't seem to disturb the probe.
Sorry for the noise.

Andrea
