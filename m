Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3CMJwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:52:01 -0400
Received: from mail.nanl.de ([217.115.11.12]:52720 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3CMJwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <1363165170.3137.182.camel@x61.thuisdomein>
References: <1363165170.3137.182.camel@x61.thuisdomein>
From: Jonas Gorski <jogo@openwrt.org>
Date: Wed, 13 Mar 2013 10:51:33 +0100
Message-ID: <CAOiHx=n4a26z=PS02E2KjD2Y3Pp0P0x-5Ns6WRc-WScNF=EO_Q@mail.gmail.com>
Subject: Re: rt2x00: Kconfig symbols RALINK_RT288X and RALINK_RT305X
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2013 09:59, Paul Bolle <pebolle@tiscali.nl> wrote:
> 0) Support for rt2800pci (or "the rt2860/rt3090 chipsets") was added in
> v2.6.33 (three years ago). References to the related Kconfig symbols
> RALINK_RT288X and RALINK_RT305X were introduced in that release. So were
> checks for their macros (CONFIG_RALINK_RT288X and CONFIG_RALINK_RT305X).
>
> 1) The Kconfig symbols themselves were never added in mainline. So these
> references and macros appear to be just markers for dead code in
> mainline, as that code will not be built.
>
> 2) This was previously discussed in
> https://lkml.org/lkml/2010/7/14/110 . The patch submitted in that
> message (which would remove all the dead code at the time) did not get
> applied.
>
> 3) What is the current status of the (out of tree) code that adds
> RALINK_RT288X and RALINK_RT305X?

They are now present in 3.9-rc1, see a0b0197c (more specifically
85639910..d3d2b420) :)

The actual accepted Kconfig symbol names are different though, so they
should be changed in rt2x00 to match them (SOC_RT288X and SOC_RT305X).


Jonas
