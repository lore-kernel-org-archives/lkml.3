Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3H3NsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:48:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51261 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3H3NsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:48:10 -0400
Date: Fri, 30 Aug 2013 14:47:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org, dave.martin@arm.com,
        msalter@redhat.com
Subject: Re: [PATCH 14/16] Add strstr to compressed string.c for ARM.
Message-ID: <20130830134754.GX6617@n2100.arm.linux.org.uk>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-15-git-send-email-roy.franz@linaro.org> <20130830134325.51DC83E102A@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830134325.51DC83E102A@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 02:43:25PM +0100, Grant Likely wrote:
> On Fri,  9 Aug 2013 16:26:15 -0700, Roy Franz <roy.franz@linaro.org> wrote:
> > The shared efi-stub-helper.c functions require a strstr
> > implementation.
> > Implementation copied from arch/x86/boot/string.c
> > 
> > Signed-off-by: Roy Franz <roy.franz@linaro.org>
> 
> Okay, but at some point arch/arm/boot/compressed/string.c should be
> reworked into a common place.

Only if the common place can be built with arch specific compile options,
like -fpic, without impacting the rest of the kernel.
