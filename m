Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab3HNUCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:02:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41653 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3HNUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:02:36 -0400
Date: Wed, 14 Aug 2013 20:57:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: integrator: Make sure INTEGRATOR_AP depends on PCI
Message-ID: <20130814195701.GY23006@n2100.arm.linux.org.uk>
References: <1376509818-22163-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376509818-22163-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:50:18PM +0200, Joerg Roedel wrote:
> Add this dependency to the Kconfig file to fix the following
> build error when CONFIG_INTEGRATOR_AP is set but CONFIG_PCI
> is not:

No, integrator does not require PCI, so this needs to be fixed by other
means, such as finding out how the breakage was introduced, and fixing
the real cause of this regression.
