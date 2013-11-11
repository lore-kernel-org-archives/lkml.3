Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3KKQPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:15:08 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48785 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab3KKQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:15:03 -0500
Date: Mon, 11 Nov 2013 16:14:57 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH] EFI: Delete out-of-date comments of
 efi_query_variable_store
Message-ID: <20131111161457.GI22636@console-pimps.org>
References: <87y54wny1c.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y54wny1c.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Nov, at 10:15:11PM, Madper Xie wrote:
> 
> For now we only ensure about 5kb free space for avoiding our board
> refusing boot. But the comment lies that we retain 50% space.
> 
> Signed-off-by: Madper Xie <cxie@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Applied, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
