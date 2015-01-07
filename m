Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbbAGGl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:41:59 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50134 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754952AbbAGGl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:41:58 -0500
Date: Wed, 7 Jan 2015 07:41:54 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ken Wilson <ken.wilson@opengear.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, gerg@uclinux.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        broonie@kernel.org, ezequiel.garcia@free-electrons.com,
        galak@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: orion: Add multiple chip select support for Armada
 370 and 375
Message-ID: <20150107074154.1334b5c0@free-electrons.com>
In-Reply-To: <54AC5B16.9020206@free-electrons.com>
References: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com>
	<54AC5B16.9020206@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Tue, 06 Jan 2015 23:00:54 +0100, Gregory CLEMENT wrote:

> On 06/01/2015 22:30, Ken Wilson wrote:
> > Create a new dt binding for the Armada 375 that supports up to
> > 3 chip selects but uses the same prescaler values and algorithm
> > as the basic orion binding.
> 
> There was already a patch that have been sent for this:
> http://thread.gmane.org/gmane.linux.kernel.spi.devel/17808/focus=17809
> 
> but in the end it has not been merged. The last email on the thread was
> about doing the manipulation in set_cs and not in setup_transfer(). And I
> didn't find a newer version.
> 
> Maybe it just fell through the cracks.
> Thomas did you remember of it?

Yes, it is still on my TODO-list, but I haven't yet gotten around to
submitting a new version. So I haven't looked at Ken's contribution,
but if Ken is willing to bring it up to a state where it can be
mainlined, that would definitely be welcome.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
