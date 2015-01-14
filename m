Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbbANRoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:44:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40153 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752086AbbANRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:44:23 -0500
Date: Wed, 14 Jan 2015 17:44:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vitaly Andrianov <vitalya@ti.com>
Cc: thomas.petazzoni@free-electrons.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [Resend PATCH] ARM: mm: use phys_addr_t in ioremap_page functions
Message-ID: <20150114174407.GB12302@n2100.arm.linux.org.uk>
References: <1421257452-18834-1-git-send-email-vitalya@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421257452-18834-1-git-send-email-vitalya@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:44:12PM -0500, Vitaly Andrianov wrote:
> On a 32 bit ARM architecture with LPAE extension physical addresses
> cannot fit into unsigned long variable.
> 
> This patch fixes the ioremap_page function.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Acked-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> - Fixing the commit log and resending

Still not happy.  Why do we even need this function which no one calls.
Please delete it instead.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
