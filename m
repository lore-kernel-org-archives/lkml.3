Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaJHW5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:57:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaJHW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:57:50 -0400
Date: Wed, 8 Oct 2014 15:57:50 -0700
From: Greg KH <greg@kroah.com>
To: Igor Bogomazov <ygrex@ygrex.ru>
Cc: devel@driverdev.osuosl.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: coding style fixup
Message-ID: <20141008225750.GB10158@kroah.com>
References: <20141007131142.56ef73a7@ygrex-lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007131142.56ef73a7@ygrex-lenovo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:11:42PM +0400, Igor Bogomazov wrote:
> checkpatch.pk tiny fix
> get rid of 2 warnings and 2 errors for hal/fw.c
>     
> Signed-off-by: Igor Bogomazov <ygrex@ygrex.ru>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: navin patidar <navin.patidar@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
> linux-next 3.17.0

I think someone else already did this before you sent it in, as this
doesn't apply to my tree, sorry :(
