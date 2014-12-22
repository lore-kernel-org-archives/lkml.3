Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaLVC4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:56:45 -0500
Received: from ozlabs.org ([103.22.144.67]:44281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaLVC4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:56:44 -0500
In-Reply-To: <1419115353-12374-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: arch: powerpc: platforms: embedded6xx: mpc7448_hpc2.c: Remove some unused functions
Message-Id: <20141222025643.53D8A1400E7@ozlabs.org>
Date: Mon, 22 Dec 2014 13:56:43 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-20-12 at 22:42:32 UTC, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> mpc7448_hpc2_halt() mpc7448_hpc2_power_off()

The other option would be to wire it up.

But the default implementations do more or less the same thing.

As far as I can see these were introduced in c5d56332fd6c "[POWERPC] Add
general support for mpc7448hpc2 (Taiga) platform" and never used.

cheers
