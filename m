Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FCIL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:11:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51661 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3FCILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:11:51 -0400
Date: Mon, 3 Jun 2013 10:11:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603081148.GB13607@nazgul.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130602225620.GA5496@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 11:56:20PM +0100, Matthew Garrett wrote:
> I've just run Windows 8 under a hacked up copy of OVMF that dumps
> the data passed to SetVirtualAddressMap. It seems that Windows *is*
> mapping the runtime services to higher addresses - so presumably the
> 1:1 mapping is in addition to the virtual mapping.

But but, once we call SetVirtualAddressMap with the set of addresses of
the runtime services, only those can be used after, right? If so, we
can't have both (this is at least my understanding)...

Thanks.
