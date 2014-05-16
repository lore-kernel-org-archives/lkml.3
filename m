Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaEPM5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:57:21 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50890 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755234AbaEPM5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:57:17 -0400
Date: Fri, 16 May 2014 13:55:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140516125545.GO3693@n2100.arm.linux.org.uk>
References: <1364507176.1345.45.camel@x61.thuisdomein> <8309592.drxAj71PnZ@wuerfel> <1400059550.31197.12.camel@x220> <4305975.PvMXZQ020k@wuerfel> <1400232598.20342.16.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400232598.20342.16.camel@x220>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:29:58AM +0200, Paul Bolle wrote:
> Support for ARM710 CPUs was removed in v3.5. But a few lines of ARM710
> specific assembler code were left in the tree. Remove these too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> This minor cleanup was suggested by Arnd. This patch is mostly
> guesswork, as I already told Arnd, since I have never touched ARM
> assembler before (as far as I can remember). Untested too! And this does
> need testing.

NAK.

There was a CPU called the ARM710, it was ARMv3 and it had no Thumb support.

There is also a CPU called the ARM710T, which is ARMv4 and has Thumb support.

These are two completely different CPUs, the former was removed along with
the removal of ARMv3 support.  The latter remains because we still support
ARMv4.

This is a nice instance of arm-soc people thinking that they are somehow
authoritive for core ARM stuff...

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
