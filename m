Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3FCOyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:54:18 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52688 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758076Ab3FCOyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:54:15 -0400
Date: Mon, 3 Jun 2013 15:54:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603145412.GJ2004@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <20130603143252.GB20252@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603143252.GB20252@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jun, at 03:32:52PM, Matthew Garrett wrote:
> We can only pass one set of addresses to SetVirtualAddressMap(), but it 
> doesn't seem like there's any intrinsic reason we can't the runtime 
> regions mapped to multiple virtual addresses.

Indeed. That's the approach I took with my 1:1 series from last year. If
Windows is mapping things at higher addresses like you said, then
they're probably doing the same.

-- 
Matt Fleming, Intel Open Source Technology Center
