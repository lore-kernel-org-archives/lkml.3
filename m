Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaCDR1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:27:52 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:45806 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbaCDR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:27:51 -0500
Date: Tue, 4 Mar 2014 17:27:24 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Russ Anderson <rja@sgi.com>, Alex Thorlton <athorlton@sgi.com>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] efi: Quirk out SGI UV
Message-ID: <20140304172130.GB3037@console-pimps.org>
References: <1393948937-21840-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393948937-21840-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar, at 05:02:17PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Getting this thing to work with the new mapping scheme would need more
> work.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/efi.h  |  1 +
>  arch/x86/kernel/setup.c     | 10 ++--------
>  arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
>  3 files changed, 23 insertions(+), 8 deletions(-)

Thanks, applied to 'urgent' with an updated commit message.

-- 
Matt Fleming, Intel Open Source Technology Center
