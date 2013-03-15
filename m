Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3COQRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:17:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:53019 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab3COQRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:17:10 -0400
Subject: Re: [PATCH] powerpc/qe: remove useless Kconfig default
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1363124951.3137.156.camel@x61.thuisdomein>
Date: Fri, 15 Mar 2013 11:16:38 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <61AABF0B-0F3F-4E85-98F8-4445E469EE86@kernel.crashing.org>
References: <1363124951.3137.156.camel@x61.thuisdomein>
To: Paul Bolle <pebolle@tiscali.nl>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2013, at 4:49 PM, Paul Bolle wrote:

> The Kconfig entry for QE_USB contains
> 	default y if USB_GADGET_FSL_QE
> 
> But USB_GADGET_FSL_QE got removed in commit
> 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b ("usb: gadget: allow multiple
> gadgets to be built"). This default will therefor never be set and can
> be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with "make ARCH=powerpc menuconfig" and "make ARCH=powerpc
> oldconfig" (before and after the patch). Enough to see this patch didn't
> obviously break stuff.
> 
> 1) I don't really understand commit
> 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b. Was its point that we replace
> USB_GADGET_FSL_QE with USB_FSL_QE? I couldn't tell and chose not to
> actually change any behavior.
> 
> arch/powerpc/sysdev/qe_lib/Kconfig | 1 -
> 1 file changed, 1 deletion(-)
> 

You're correct that this isn't quite right, I've posted a proper patch that should fix this correctly.

thanks for pointing it out.

- k