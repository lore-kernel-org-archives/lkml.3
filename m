Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaFWJBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38788 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752451AbaFWJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:01:41 -0400
Date: Mon, 23 Jun 2014 10:01:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
Message-ID: <20140623090130.GG32514@n2100.arm.linux.org.uk>
References: <1403499924-11214-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403499924-11214-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 01:05:24AM -0400, Mark Salter wrote:
> +config ZONE_DMA
> +	bool "32-bit DMA memory allocation"
> +	def_bool y

This should be either bool + default or def_bool.  Not bool + def_bool.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
