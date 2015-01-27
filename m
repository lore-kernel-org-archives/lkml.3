Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbbA0Vbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:31:32 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:44129 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbbA0Vbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:31:31 -0500
Date: Tue, 27 Jan 2015 21:31:30 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: arm64: USB_ARCH_HAS_EHCI
In-Reply-To: <1422351833.14015.20.camel@x220>
Message-ID: <alpine.DEB.2.02.1501272130470.19947@utopia.booyaka.com>
References: <1422351833.14015.20.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Paul Bolle wrote:

> Your commit d035fdfa27ac ("arm64: Add Tegra132 support") is included in
> today's linux-next (ie, next-20150127). I noticed because a script I use
> to check linux-next spotted a minor problem with it.
> 
> It adds a select for the Kconfig symbol USB_ARCH_HAS_EHCI. That Kconfig
> was obsoleted in v3.11 and removed in v3.15. See commit b797b76fb464
> ("usb: host: remove USB_ARCH_HAS_?HCI"). That select is now a nop.
> 
> Should I submit the trivial patch to remove that line or do you prefer
> to do that yourself?

Thanks, I'll post a new version.


- Paul
