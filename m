Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3K0MPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:15:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43545 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3K0MPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:15:00 -0500
Date: Wed, 27 Nov 2013 12:14:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Virdi <amit.virdi@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, nico@linaro.org, marc.ceeeee@gmail.com,
        spear--sw-devel@codex.cro.st.com
Subject: Re: [PATCH] ARM: asm: Configure caches as per the defconfig
Message-ID: <20131127121425.GN16735@n2100.arm.linux.org.uk>
References: <1385553244-1513-1-git-send-email-amit.virdi@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385553244-1513-1-git-send-email-amit.virdi@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 05:24:04PM +0530, Amit Virdi wrote:
> From: Amit VIRDI <Amit.VIRDI@st.com>
> 
> In the current implementation of the decompression code, the caches are enabled
> irrespective of their configuration in the deconfig. This makes setting the
> ICACHE and DCACHE disable options from the menuconfig irrelevant. Change this
> implementation to enable caches only if specified in the defconfig.

NAK.  These options are provided more for ARM Ltd's validation of CPUs
rather than for users, and it's not supposed to be used with the
decompressor.

I've already ignored one such patch like this in the past and I intend
not applying this one either.
