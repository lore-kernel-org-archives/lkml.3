Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3FBW4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:56:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59942 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3FBW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:56:24 -0400
Date: Sun, 2 Jun 2013 23:56:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130602225620.GA5496@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370177770-26661-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just run Windows 8 under a hacked up copy of OVMF that dumps the 
data passed to SetVirtualAddressMap. It seems that Windows *is* mapping 
the runtime services to higher addresses - so presumably the 1:1 mapping 
is in addition to the virtual mapping.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
