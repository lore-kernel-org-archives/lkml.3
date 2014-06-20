Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967204AbaFTNto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:49:44 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57467 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330AbaFTNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:49:43 -0400
Date: Fri, 20 Jun 2014 14:49:38 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EFI urgent fix
Message-ID: <20140620134938.GY24049@console-pimps.org>
References: <20140620090008.GU24049@console-pimps.org>
 <20140620092848.GC23939@arm.com>
 <20140620133919.GK4179@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620133919.GK4179@bivouac.eciton.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun, at 02:39:19PM, Leif Lindholm wrote:
> 
> I did post an alternative patch for one half of this a week before
> anyone else, but that one seems to have been ignored, even by gmane:
> http://www.spinics.net/lists/linux-efi/msg03924.html
 
Sorry Leif, I don't know why I didn't pick that one up. I do see it in
my mail archive. Chalk it up to human error.

> That form will still be required for the 32-bit arm support, since
> strncmp is not available in the zImage.

Are you planning on incorporating this fix into the 32-bit arm support
patch series

-- 
Matt Fleming, Intel Open Source Technology Center
