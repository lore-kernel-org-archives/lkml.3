Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3BQKVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 05:21:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44851 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3BQKVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 05:21:20 -0500
Date: Sun, 17 Feb 2013 10:19:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] of: use platform_device_add
Message-ID: <20130217101958.GR17833@n2100.arm.linux.org.uk>
References: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca> <1358473200-17886-2-git-send-email-grant.likely@secretlab.ca> <20130217030331.GA15048@S2101-09.ap.freescale.net> <20130217074317.GB16632@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217074317.GB16632@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 03:43:20PM +0800, Shawn Guo wrote:
> It also breaks all of_amba_device users.
> 
> of_amba_device_create() --> amba_device_add() --> request_resource()
> and fails.

Presumably that's because we no longer know what the parent resource
is supposed to be?
